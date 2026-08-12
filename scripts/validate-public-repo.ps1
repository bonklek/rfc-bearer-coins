$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$errors = New-Object System.Collections.Generic.List[string]

$publicFiles = Get-ChildItem -LiteralPath $repoRoot -Recurse -File | Where-Object {
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

function Get-MarkdownAnchors([string]$path) {
    if ($anchorCache.ContainsKey($path)) { return $anchorCache[$path] }
    $anchors = New-Object 'System.Collections.Generic.HashSet[string]'
    $seen = @{}
    $text = Get-Content -LiteralPath $path -Raw -Encoding UTF8
    foreach ($heading in [regex]::Matches($text, '(?m)^#{1,6}\s+(.+?)\s*#*\s*$')) {
        $slug = $heading.Groups[1].Value.ToLowerInvariant()
        $slug = [regex]::Replace($slug, '<[^>]+>', '')
        $slug = [regex]::Replace($slug, '[^\p{L}\p{Nd}\s_-]', '')
        $slug = [regex]::Replace($slug.Trim(), '\s+', '-')
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
    $text = Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8
    $links = [regex]::Matches($text, '\[[^\]]+\]\(([^)]+)\)')
    foreach ($link in $links) {
        $target = $link.Groups[1].Value.Trim('<', '>')
        if ($target -match '^(https?://|mailto:|#)') { continue }
        $pathPart = ($target -split '#', 2)[0]
        if ([string]::IsNullOrWhiteSpace($pathPart)) { continue }
        $pathPart = [Uri]::UnescapeDataString($pathPart)
        $resolved = [IO.Path]::GetFullPath((Join-Path $file.DirectoryName $pathPart))
        if (-not (Test-Path -LiteralPath $resolved)) {
            $relative = $file.FullName.Substring($repoRoot.Length + 1)
            $errors.Add("Broken local link in ${relative}: $target")
            continue
        }
        if ($target.Contains('#') -and [IO.Path]::GetExtension($resolved) -eq '.md') {
            $fragment = [Uri]::UnescapeDataString(($target -split '#', 2)[1]).ToLowerInvariant()
            $anchors = Get-MarkdownAnchors $resolved
            if (-not $anchors.Contains($fragment)) {
                $relative = $file.FullName.Substring($repoRoot.Length + 1)
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
foreach ($form in Get-ChildItem -LiteralPath $issueFormRoot -Filter '*.yml' -File) {
    if ($form.Name -eq 'config.yml') { continue }
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
