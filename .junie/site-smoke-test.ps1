Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Assert-Contains {
    param(
        [string]$Text,
        [string]$Pattern,
        [string]$Label
    )
    if ($Text -notmatch [regex]::Escape($Pattern)) {
        Write-Host "FAIL: $Label (missing '$Pattern')" -ForegroundColor Red
        return $false
    } else {
        Write-Host "OK: $Label" -ForegroundColor Green
        return $true
    }
}

$repoRoot = Get-Location
$indexPath = Join-Path $repoRoot 'index.html'
if (!(Test-Path $indexPath)) { throw "index.html not found at $indexPath" }
$html = Get-Content -Path $indexPath -Raw

$allOk = $true
$allOk = (Assert-Contains $html 'bootstrap@5.3.2' 'Bootstrap CSS CDN present') -and $allOk
$allOk = (Assert-Contains $html 'bootstrap.bundle.min.js' 'Bootstrap JS bundle present') -and $allOk
$allOk = (Assert-Contains $html 'id="shareBtn"' 'Share button exists') -and $allOk
$allOk = (Assert-Contains $html 'const PD_DATA' 'Product data object declared') -and $allOk
$allOk = (Assert-Contains $html "'black-garlic'" 'PD_DATA contains black-garlic') -and $allOk
$allOk = (Assert-Contains $html "'sidr-herbs'" 'PD_DATA contains sidr-herbs') -and $allOk
$allOk = (Assert-Contains $html 'id="searchView"' 'Search view present') -and $allOk
$allOk = (Assert-Contains $html 'id="cartView"' 'Cart view present') -and $allOk
$allOk = (Assert-Contains $html 'id="locationView"' 'Location view present') -and $allOk

if ($allOk) {
    Write-Host "ALL TESTS PASSED" -ForegroundColor Green
    exit 0
} else {
    Write-Host "Some tests failed" -ForegroundColor Red
    exit 1
}