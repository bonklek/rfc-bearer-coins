$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$errors = New-Object System.Collections.Generic.List[string]

# -Force: PowerShell on macOS/Linux treats dot-prefixed items as hidden, which
# would otherwise skip .github/ and other published dotfiles.
$publicFiles = Get-ChildItem -LiteralPath $repoRoot -Recurse -File -Force | Where-Object {
    $_.FullName -notmatch '[\\/]\.git[\\/]' -and
    $_.FullName -notmatch '[\\/]validation-output[\\/]'
}

$requiredPublicEntries = @(
    'README.md',
    'EXPLAINER.md',
    'STATUS.md',
    'GLOSSARY.md',
    'FEEDBACK.md',
    'OPEN_DECISIONS.md',
    'PUBLICATION.md',
    'DOCUMENT_AUTHORITY.md',
    'rfcs/README.md',
    'rfcs/0001-physical-bearer-cryptocurrency/README.md'
)
foreach ($entry in $requiredPublicEntries) {
    if (-not (Test-Path -LiteralPath (Join-Path $repoRoot $entry))) {
        $errors.Add("Missing public entry point: $entry")
    }
}

$contentFiles = $publicFiles | Where-Object { $_.FullName -ne $PSCommandPath }

$forbidden = [ordered]@{
    'Windows user path' = 'C:\\Users\\'
    'POSIX user path' = '/Users/'
    'Model/provider metadata' = 'gpt-'
    'Internal adjudication metadata' = 'Parent adjudication'
    'Misleading review completion flag' = 'complete:\s*true'
    'Stale status field' = 'chainObservation'
}

foreach ($file in $contentFiles) {
    $text = Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8
    foreach ($entry in $forbidden.GetEnumerator()) {
        if ($text -match $entry.Value) {
            $relative = $file.FullName.Substring($repoRoot.Length + 1)
            $errors.Add("$($entry.Key): $relative")
        }
    }
}

$markdownFiles = $publicFiles | Where-Object { $_.Extension -eq '.md' }
$anchorCache = @{}
$repoPrefix = $repoRoot.TrimEnd('\', '/') + [IO.Path]::DirectorySeparatorChar

# GitHub resolves links case-sensitively; Windows and macOS file systems
# usually do not, so Test-Path alone accepts links that 404 once published.
function Test-ExactCasePath([string]$path) {
    $current = $repoRoot
    $parts = $path.Substring($repoPrefix.Length).Split([char[]]@('\', '/'), [StringSplitOptions]::RemoveEmptyEntries)
    foreach ($part in $parts) {
        $match = Get-ChildItem -LiteralPath $current -Force | Where-Object { $_.Name -ceq $part }
        if (-not $match) { return $false }
        $current = $match.FullName
    }
    return $true
}

# Blank every line of a fenced code block (``` or ~~~) so headings and links
# shown as code are not parsed. A fence closes only on the same character with
# at least the opening length; an unclosed fence runs to the end of the file.
function Remove-FencedCodeBlocks([string]$text) {
    $lines = $text -split "`r?`n"
    $fence = $null
    for ($i = 0; $i -lt $lines.Length; $i++) {
        $line = $lines[$i]
        if ($null -eq $fence) {
            $open = [regex]::Match($line, '^\s*(`{3,}|~{3,})')
            if (-not $open.Success) { continue }
            $marker = $open.Groups[1].Value
            # A backtick fence's info string cannot contain a backtick.
            if ($marker[0] -eq [char]'`' -and $line.Substring($open.Length).Contains('`')) { continue }
            $fence = $marker
            $lines[$i] = ''
        } else {
            $lines[$i] = ''
            $close = [regex]::Match($line, '^\s*(`{3,}|~{3,})\s*$')
            if ($close.Success) {
                $closer = $close.Groups[1].Value
                if ($closer[0] -eq $fence[0] -and $closer.Length -ge $fence.Length) {
                    $fence = $null
                }
            }
        }
    }
    return ($lines -join "`n")
}

function Get-MarkdownAnchors([string]$path) {
    if ($anchorCache.ContainsKey($path)) { return $anchorCache[$path] }
    $anchors = New-Object 'System.Collections.Generic.HashSet[string]'
    $seen = @{}
    $text = Remove-FencedCodeBlocks (Get-Content -LiteralPath $path -Raw -Encoding UTF8)
    foreach ($heading in [regex]::Matches($text, '(?m)^#{1,6}\s+(.+?)\s*#*\s*$')) {
        $slug = $heading.Groups[1].Value.ToLowerInvariant()
        # GitHub slugs the rendered text, so [text](target) contributes only text.
        $slug = [regex]::Replace($slug, '(?<!!)\[([^\]]*)\]\([^)]*\)', '$1')
        $slug = [regex]::Replace($slug, '<[^>]+>', '')
        # GitHub: drop everything except word characters, hyphens and spaces,
        # then map each space to one hyphen (runs of spaces are not collapsed).
        $slug = [regex]::Replace($slug, '[^\p{L}\p{M}\p{Nd}\p{Pc} -]', '')
        $slug = $slug.Replace(' ', '-')
        if ($seen.ContainsKey($slug)) {
            $seen[$slug]++
            $slug = "$slug-$($seen[$slug])"
        } else {
            $seen[$slug] = 0
        }
        [void]$anchors.Add($slug)
    }
    $anchorCache[$path] = $anchors
    return $anchors
}

foreach ($file in $markdownFiles) {
    $text = Remove-FencedCodeBlocks (Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8)
    $links = [regex]::Matches($text, '\[[^\]]+\]\(([^)]+)\)')
    foreach ($link in $links) {
        # Drop an optional link title: [x](a.md "t") or [x](a.md 't').
        $target = [regex]::Replace($link.Groups[1].Value.Trim(), '\s+("[^"]*"|''[^'']*'')$', '')
        $target = $target.Trim('<', '>')
        if ($target -match '^(https?://|mailto:|#)') { continue }
        $pathPart = ($target -split '#', 2)[0]
        if ([string]::IsNullOrWhiteSpace($pathPart)) { continue }
        $pathPart = [Uri]::UnescapeDataString($pathPart)
        $resolved = [IO.Path]::GetFullPath((Join-Path $file.DirectoryName $pathPart))
        $relative = $file.FullName.Substring($repoRoot.Length + 1)
        if ($resolved -ne $repoRoot -and -not $resolved.StartsWith($repoPrefix, [StringComparison]::Ordinal)) {
            $errors.Add("Local link leaves the repository in ${relative}: $target")
            continue
        }
        if (-not (Test-Path -LiteralPath $resolved) -or -not (Test-ExactCasePath $resolved)) {
            $errors.Add("Broken local link in ${relative}: $target")
            continue
        }
        if ($target.Contains('#') -and [IO.Path]::GetExtension($resolved) -eq '.md') {
            $fragment = [Uri]::UnescapeDataString(($target -split '#', 2)[1]).ToLowerInvariant()
            $anchors = Get-MarkdownAnchors $resolved
            if (-not $anchors.Contains($fragment)) {
                $errors.Add("Broken heading anchor in ${relative}: $target")
            }
        }
    }
}

$allMarkdown = ($markdownFiles | ForEach-Object {
    Get-Content -LiteralPath $_.FullName -Raw -Encoding UTF8
}) -join "`n"

$claimSchemaCount = [regex]::Matches($allMarkdown, 'ClaimIntent\s*\{').Count
if ($claimSchemaCount -ne 1) {
    $errors.Add("Expected one canonical ClaimIntent field list; found $claimSchemaCount")
}

$complaintsPath = Join-Path $repoRoot 'COMPLAINTS.md'
$complaints = Get-Content -LiteralPath $complaintsPath -Raw -Encoding UTF8
$statusMatches = [regex]::Matches($complaints, '(?m)^- \*\*Status:\*\* (.+)$')
$statusCounts = @{}
foreach ($match in $statusMatches) {
    $status = $match.Groups[1].Value.Trim()
    if (-not $statusCounts.ContainsKey($status)) { $statusCounts[$status] = 0 }
    $statusCounts[$status]++
}

$expectedStatuses = [ordered]@{
    'Open' = 77
    'Partially addressed' = 18
    'Resolved' = 1
}
foreach ($entry in $expectedStatuses.GetEnumerator()) {
    $actual = if ($statusCounts.ContainsKey($entry.Key)) { $statusCounts[$entry.Key] } else { 0 }
    if ($actual -ne $entry.Value) {
        $errors.Add("Complaint count mismatch for $($entry.Key): expected $($entry.Value), found $actual")
    }
}
if ($statusMatches.Count -ne 96) {
    $errors.Add("Expected 96 complaint statuses; found $($statusMatches.Count)")
}

$criticalCount = [regex]::Matches($complaints, '(?m)^- \*\*Severity:\*\* Critical$').Count
if ($criticalCount -ne 7) {
    $errors.Add("Expected 7 Critical complaints; found $criticalCount")
}

if (Test-Path -LiteralPath (Join-Path $repoRoot 'review-queue')) {
    $errors.Add('Raw review-queue directory must remain outside the public repository')
}

$issueFormRoot = Join-Path $repoRoot '.github/ISSUE_TEMPLATE'
# GitHub accepts both .yml and .yaml issue forms.
$issueForms = Get-ChildItem -LiteralPath $issueFormRoot -File | Where-Object { $_.Extension -in '.yml', '.yaml' }
foreach ($form in $issueForms) {
    if ($form.BaseName -eq 'config') { continue }
    $formText = Get-Content -LiteralPath $form.FullName -Raw -Encoding UTF8
    foreach ($requiredKey in @('name', 'description', 'body')) {
        if ($formText -notmatch "(?m)^${requiredKey}:") {
            $errors.Add("Issue form $($form.Name) is missing required top-level key: $requiredKey")
        }
    }
}

if ($errors.Count -gt 0) {
    Write-Host 'Public-repository validation failed:' -ForegroundColor Red
    $errors | ForEach-Object { Write-Host "- $_" }
    exit 1
}

Write-Host "Public-repository validation passed: $($publicFiles.Count) files, 96 complaints, 7 Critical."
