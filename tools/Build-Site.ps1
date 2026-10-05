param(
    [string]$OutputPath = "_site"
)

$ErrorActionPreference = "Stop"

function ConvertTo-HtmlText {
    param([AllowNull()][string]$Value)
    return [System.Net.WebUtility]::HtmlEncode($Value)
}

function New-SiteShell {
    param(
        [string]$Title,
        [string]$Main
    )

    return @"
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>$([System.Net.WebUtility]::HtmlEncode($Title))</title>
    <link rel="icon" type="image/png" href="assets/images/sick-s-logo.png">
    <link rel="stylesheet" href="assets/site/site.css">
  </head>
  <body>
    <header class="site-header">
      <div class="site-header__inner">
        <a class="brand" href="index.html">
          <img class="brand__logo" src="assets/images/sick-logo-transparent.png" alt="SICK">
          <span>RFID Warehouse Track and Trace</span>
        </a>
        <nav class="nav" aria-label="Primary navigation">
          <a href="index.html">Manuals</a>
        </nav>
      </div>
    </header>
    <main class="site-main">
$Main
    </main>
    <footer class="site-footer">
      <span>&copy; <span data-current-year></span> SICK Engineering Hub APAC</span>
    </footer>
    <script src="assets/site/site.js"></script>
  </body>
</html>
"@
}

function New-ManualVersionsHtml {
    param($Manifest)

    $versionLinks = @($Manifest.versions) | ForEach-Object {
        $version = ConvertTo-HtmlText $_.version
        $status = ConvertTo-HtmlText $_.status
        $date = ConvertTo-HtmlText $_.date
        $summary = ConvertTo-HtmlText $_.summary
        $compatibility = ConvertTo-HtmlText (Convert-VersionCompatibilityToText $_)
        @"
          <li>
            <a href="$version/index.html">
              <span><strong>$version</strong> $summary<br><small>$compatibility</small></span>
              <span>$status $date</span>
            </a>
          </li>
"@
    }

    $title = ConvertTo-HtmlText $Manifest.title
    $description = ConvertTo-HtmlText $Manifest.description
    $latest = ConvertTo-HtmlText $Manifest.latest

    return @"
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>$title versions</title>
    <link rel="icon" type="image/png" href="../../assets/images/sick-s-logo.png">
    <link rel="stylesheet" href="../../assets/site/site.css">
  </head>
  <body>
    <header class="site-header">
      <div class="site-header__inner">
        <a class="brand" href="../../index.html">
          <img class="brand__logo" src="../../assets/images/sick-logo-transparent.png" alt="SICK">
          <span>RFID Warehouse Track and Trace</span>
        </a>
        <nav class="nav" aria-label="Primary navigation">
          <a href="../../index.html">Manuals</a>
          <a href="index.html">Latest</a>
        </nav>
      </div>
    </header>
    <main class="site-main">
      <section class="hero">
        <p class="eyebrow">Manual versions</p>
        <h1>$title</h1>
        <p class="lead">$description</p>
        <p><a href="index.html">Open latest version ($latest)</a></p>
      </section>
      <ul class="version-list">
$($versionLinks -join "")
      </ul>
    </main>
    <footer class="site-footer">
      <span>&copy; <span data-current-year></span> SICK Engineering Hub APAC</span>
    </footer>
    <script src="../../assets/site/site.js"></script>
  </body>
</html>
"@
}

function New-LatestRedirectHtml {
    param($Manifest)

    $title = ConvertTo-HtmlText $Manifest.title
    $description = ConvertTo-HtmlText $Manifest.description
    $latest = ConvertTo-HtmlText $Manifest.latest

    return @"
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="refresh" content="0; url=$latest/index.html">
    <title>$title latest</title>
    <link rel="icon" type="image/png" href="../../assets/images/sick-s-logo.png">
    <link rel="stylesheet" href="../../assets/site/site.css">
  </head>
  <body>
    <header class="site-header">
      <div class="site-header__inner">
        <a class="brand" href="../../index.html">
          <img class="brand__logo" src="../../assets/images/sick-logo-transparent.png" alt="SICK">
          <span>RFID Warehouse Track and Trace</span>
        </a>
        <nav class="nav" aria-label="Primary navigation">
          <a href="../../index.html">Manuals</a>
          <a href="versions.html">Versions</a>
        </nav>
      </div>
    </header>
    <main class="site-main">
      <section class="hero">
        <p class="eyebrow">Latest version</p>
        <h1>$title</h1>
        <p class="lead">$description</p>
        <p><a href="$latest/index.html">Open latest version ($latest)</a></p>
      </section>
    </main>
    <footer class="site-footer">
      <span>&copy; <span data-current-year></span> SICK Engineering Hub APAC</span>
    </footer>
    <script src="../../assets/site/site.js"></script>
  </body>
</html>
"@
}

function Convert-VersionCompatibilityToText {
    param($VersionInfo)

    $appVersions = @($VersionInfo.compatibleAppVersions) | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_) }
    if ($appVersions.Count -eq 0) {
        return "Compatibility not specified"
    }

    return "Compatible app: " + ($appVersions -join ", ")
}

function Add-ManualSiteNavigation {
  param(
    [string]$ManualRoot,
    [string]$SitePrefix,
    [string]$VersionsPrefix
  )

  Get-ChildItem -LiteralPath $ManualRoot -Filter "*.html" -Recurse -File | ForEach-Object {
    $relativeDirectory = $_.DirectoryName.Substring($ManualRoot.Length).Trim('\', '/')
    $depth = if ($relativeDirectory) { @($relativeDirectory -split '[\\/]').Count } else { 0 }
    $prefix = "../" * $depth
    $navigation = @"
<nav class="nav">
      <div class="nav-group">Documentation</div>
      <a href="$prefix${SitePrefix}index.html">Documentation Home</a>
      <a href="$prefix${VersionsPrefix}versions.html">Manual Versions</a>
"@
    $content = Get-Content -Raw -LiteralPath $_.FullName -Encoding UTF8
    $content = $content.Replace('<nav class="nav">', $navigation)
    $favicon = "    <link rel=`"icon`" type=`"image/png`" href=`"$prefix${SitePrefix}assets/images/sick-s-logo.png`" />"
    $content = $content.Replace('  </head>', "$favicon`n  </head>")
    Set-Content -LiteralPath $_.FullName -Value $content -Encoding UTF8
  }
}

function Update-AliasHtmlPaths {
    param(
        [string]$AliasRoot,
        [string]$Slug
    )

    Get-ChildItem -LiteralPath $AliasRoot -Filter "*.html" -Recurse -File | ForEach-Object {
      $content = Get-Content -Raw -LiteralPath $_.FullName -Encoding UTF8
        $content = $content.Replace("../../../assets/", "../assets/")
        $content = $content.Replace("../../../index.html", "../index.html")
        $content = $content.Replace("../versions.html", "../manuals/$Slug/versions.html")
        Set-Content -LiteralPath $_.FullName -Value $content -Encoding UTF8
    }
}

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$manualsRoot = Join-Path $repoRoot "manuals"
$assetsRoot = Join-Path $repoRoot "assets"
$resolvedOutput = if ([System.IO.Path]::IsPathRooted($OutputPath)) {
    $OutputPath
} else {
    Join-Path $repoRoot $OutputPath
}

if (Test-Path $resolvedOutput) {
    Remove-Item -LiteralPath $resolvedOutput -Recurse -Force
}

New-Item -ItemType Directory -Path $resolvedOutput | Out-Null
Set-Content -LiteralPath (Join-Path $resolvedOutput ".nojekyll") -Value "" -Encoding ASCII

if (Test-Path $assetsRoot) {
    Copy-Item -Path $assetsRoot -Destination (Join-Path $resolvedOutput "assets") -Recurse -Force
}

$manualEntries = @()
$manifestFiles = Get-ChildItem -LiteralPath $manualsRoot -Directory | ForEach-Object {
  $manifestPath = Join-Path $_.FullName "manifest.json"
  if (Test-Path -LiteralPath $manifestPath -PathType Leaf) {
    Get-Item -LiteralPath $manifestPath
  }
} |
    Sort-Object FullName

foreach ($manifestFile in $manifestFiles) {
    $manifest = Get-Content -Raw -LiteralPath $manifestFile.FullName | ConvertFrom-Json
    $manualRoot = Split-Path -Parent $manifestFile.FullName
    $slug = [string]$manifest.slug

    if ([string]::IsNullOrWhiteSpace($slug)) {
        throw "Missing slug in $($manifestFile.FullName)"
    }

    $manualOutputRoot = Join-Path $resolvedOutput "manuals/$slug"
    New-Item -ItemType Directory -Path $manualOutputRoot -Force | Out-Null

    $versions = @($manifest.versions)
    if ($versions.Count -eq 0) {
        throw "No versions declared in $($manifestFile.FullName)"
    }

    $latestFound = $false
    foreach ($versionInfo in $versions) {
        $version = [string]$versionInfo.version
        if ([string]::IsNullOrWhiteSpace($version)) {
            throw "A version entry in $($manifestFile.FullName) is missing a version value"
        }

        $sourceVersionPath = Join-Path $manualRoot "versions/$version"
        $sourceIndex = Join-Path $sourceVersionPath "index.html"
        if (-not (Test-Path $sourceIndex)) {
            throw "Missing index.html for $slug $version at $sourceIndex"
        }

        Copy-Item -Path $sourceVersionPath -Destination (Join-Path $manualOutputRoot $version) -Recurse -Force
        Add-ManualSiteNavigation -ManualRoot (Join-Path $manualOutputRoot $version) -SitePrefix "../../../" -VersionsPrefix "../"

        if ($version -eq [string]$manifest.latest) {
            $latestFound = $true
        }
    }

    if (-not $latestFound) {
        throw "Latest version '$($manifest.latest)' is not declared in $($manifestFile.FullName)"
    }

    Set-Content -LiteralPath (Join-Path $manualOutputRoot "versions.html") -Value (New-ManualVersionsHtml -Manifest $manifest) -Encoding UTF8
    Set-Content -LiteralPath (Join-Path $manualOutputRoot "index.html") -Value (New-LatestRedirectHtml -Manifest $manifest) -Encoding UTF8

    $publicPath = [string]$manifest.publicPath
    if (-not [string]::IsNullOrWhiteSpace($publicPath)) {
        $publicPath = $publicPath.Trim("/")
        $aliasRoot = Join-Path $resolvedOutput $publicPath
        if (Test-Path $aliasRoot) {
            Remove-Item -LiteralPath $aliasRoot -Recurse -Force
        }

        $latestSourceVersionPath = Join-Path $manualRoot "versions/$($manifest.latest)"
        Copy-Item -Path $latestSourceVersionPath -Destination $aliasRoot -Recurse -Force
        Update-AliasHtmlPaths -AliasRoot $aliasRoot -Slug $slug
        Add-ManualSiteNavigation -ManualRoot $aliasRoot -SitePrefix "../" -VersionsPrefix "../manuals/$slug/"
    }

    $manualEntries += [pscustomobject]@{
        Slug = $slug
        Title = [string]$manifest.title
        Description = [string]$manifest.description
        PublicPath = [string]$manifest.publicPath
        ManualType = [string]$manifest.manualType
        Latest = [string]$manifest.latest
        Compatibility = Convert-VersionCompatibilityToText (($versions | Where-Object { [string]$_.version -eq [string]$manifest.latest }) | Select-Object -First 1)
        Versions = $versions
    }
}

$cards = $manualEntries | ForEach-Object {
    $title = ConvertTo-HtmlText $_.Title
    $description = ConvertTo-HtmlText $_.Description
    $slug = ConvertTo-HtmlText $_.Slug
    $publicPath = if ([string]::IsNullOrWhiteSpace($_.PublicPath)) { "manuals/$slug" } else { ConvertTo-HtmlText $_.PublicPath }
    $latest = ConvertTo-HtmlText $_.Latest
    $compatibility = ConvertTo-HtmlText $_.Compatibility
    @"
        <a class="manual-card" href="$publicPath/index.html">
          <h2>$title</h2>
          <p>$description</p>
          <div class="manual-card__meta">
            <span class="badge">Latest $latest</span>
            <span class="badge">$compatibility</span>
            <span class="badge">$(@($_.Versions).Count) version(s)</span>
          </div>
        </a>
"@
}

$main = @"
      <section class="hero">
        <p class="eyebrow">Public documentation</p>
        <h1>RFID Warehouse Track and Trace Documentation</h1>
        <p class="lead">
          End-user documentation for operating, monitoring, configuring, and
          administering the RFID Warehouse Track and Trace system.
        </p>
      </section>
      <section class="manual-grid" aria-label="Documentation list">
$($cards -join "")
      </section>
"@

Set-Content -LiteralPath (Join-Path $resolvedOutput "index.html") -Value (New-SiteShell -Title "RFID Warehouse Track and Trace" -Main $main) -Encoding UTF8

Write-Host "Built static site at $resolvedOutput"
