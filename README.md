# RFID Warehouse Track and Trace Documentation

Public GitHub Pages documentation for the SICK RFID Warehouse Track and Trace
system, adapted from the AI LOTO Monitoring documentation site's layout and
PowerShell build. The supplied screenshot-enhanced v1.0.0 manual and its assets
are preserved in the versioned source directory.

## Entry Points

| Path | Content |
| --- | --- |
| `/` | Documentation homepage |
| `/usage-manual/` | Latest end-user manual, with all pages and screenshots |
| `/manuals/rfid-warehouse-track-and-trace/versions.html` | Published manual versions |
| `/manuals/rfid-warehouse-track-and-trace/v1.0.0/` | Permanent v1.0.0 manual |

These paths are relative to the GitHub Pages repository URL, not the domain root.

## Repository Layout

```text
.github/workflows/deploy-pages.yml     Tag-triggered build, validation, deployment
assets/                              Shared reference-site styles and SICK branding
manuals/rfid-warehouse-track-and-trace/
  manifest.json                      Published versions and latest-manual selection
  versions/v1.0.0/                   Original manual HTML, metadata, and assets
tools/Build-Site.ps1                  Generates the static site and navigation
tools/check-site.mjs                 Checks HTML links, anchors, and asset paths
tools/release-docs.sh                 Validates and pushes an annotated release tag
_site/                               Generated output, ignored by Git
```

## Build And Preview

Install Node.js 22 or newer and PowerShell. From this directory:

```powershell
npm ci
.\tools\Build-Site.ps1
npm run check
Start-Process .\_site\index.html
```

On Linux or macOS with PowerShell installed, run
`pwsh -NoProfile -File tools/Build-Site.ps1` instead. The `npm run build`
shortcut uses Windows PowerShell.

No development server is required. All pages work as local HTML files. The
validator checks case-sensitive local links, fragment anchors, linked images,
stylesheets, scripts, downloads, and refresh redirects. It rejects root-relative
URLs that would break on GitHub project Pages. It does not check external sites
or JavaScript-generated links; browser checks cover screenshot loading and UI
interactions.

## GitHub Setup

The source repository is
`https://github.com/SICK-Engineering-Hub-APAC/rfid-warehouse-track-and-trace-documentation`.
All source files belong in the local `rfid-warehouse-track-and-trace-documentation`
repository; generated output and dependencies are ignored by Git.

1. In GitHub **Settings > Pages > Build and deployment**, select **GitHub Actions**.
2. Ensure Actions are enabled. If the `github-pages` environment has deployment
   restrictions, allow release tags as well as any branch used for manual runs.
3. Push a new tag or start **Deploy GitHub Pages** from the Actions tab.

The published URL is
`https://sick-engineering-hub-apac.github.io/rfid-warehouse-track-and-trace-documentation/`.
No custom domain is assumed.

## Publish A Release

The workflow runs on **every pushed tag**, including tags containing `/`, and
supports manual `workflow_dispatch`. A tag created only locally does not deploy.
It checks out the tagged commit, builds the site, validates links and assets,
and publishes only if validation succeeds. Branch pushes alone do not deploy.

After committing and pushing your documentation changes, use Git Bash:

```bash
npm ci
./tools/release-docs.sh --tag v1.0.0
```

The helper builds and validates first, rejects a dirty working tree and duplicate
tags, then creates and pushes an annotated tag. Tags require the `vX.Y.Z` format;
the published manual directory remains `v1.0.0`. When `--tag` is omitted, it reads
`latest` from the publication manifest. `--skip-build` skips local build and link
validation; CI still validates before publishing.

Alternatively, after local validation:

```bash
git tag -a v1.0.0 -m "Release RFID documentation v1.0.0"
git push origin v1.0.0
```

Do not reuse an existing release tag. Confirm successful deployment and the
published URL in the workflow's deployment job.

## Add A Manual Version

1. Put the complete new manual and assets in
   `manuals/rfid-warehouse-track-and-trace/versions/vX.Y.Z/`.
2. Add a version entry to the top-level publication manifest, including its
   compatibility, summary, status, and release date when known. Update `latest`
   to the new version; retain older entries and directories.
3. Build, run the link checker, and review the generated pages in a browser.
4. Commit and push the changes, then push a new release tag.

The tag triggers publication; it does not change `latest` or invent manual
content. For documentation-only updates to an existing manual, use a new unused
release tag without changing the manual version unless appropriate. The manual's
original nested `manifest.json` is source metadata, not a publication manifest.