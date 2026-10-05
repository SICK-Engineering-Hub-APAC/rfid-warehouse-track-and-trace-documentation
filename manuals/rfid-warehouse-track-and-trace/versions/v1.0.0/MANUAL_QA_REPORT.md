# Manual QA Report — RFID Warehouse Track and Trace v1.0.0

## Revision applied

- Removed the **Application containers** section and container-architecture image from the end-user System chapter.
- Removed the sidebar navigation search field.
- Removed the documentation site's Light/Dark toggle and theme persistence.
- Removed the documentation site's Print button and print-specific stylesheet behavior.
- Reduced displayed Handheld screenshots to a compact centered size.
- Expanded the Handheld chapter using the latest source implementation: navigation/status, RFID Tag Search, Rack QR Search, Rack Stock Take, backend confirmation, recovery, Settings, Diagnostics, offline sync and CipherLab configuration.
- Added 23 clearly labeled Handheld screenshot placeholders for future replacement with the correct live app captures.
- Removed the separate Admin theme section from this documentation revision.

## Automated checks

The package was checked for removed UI strings/features and for broken local links/assets.


## UI style revision

The documentation shell was updated to follow the structure and visual language of the supplied reference HTML manual:

- white fixed left sidebar with grouped navigation;
- SICK Synergy-inspired colors, borders, typography and cards;
- sticky top page header;
- centered content column;
- consistent figure/table/callout/step styling;
- responsive mobile sidebar menu;
- smaller Handheld screenshots retained;
- screenshot placeholders retained;
- sidebar search remains removed;
- documentation light/dark theme switching remains removed;
- print feature remains removed.

The manual content and workflow guidance were not changed as part of this styling revision.


## Generic deployment wording revision

The manual was revised to avoid presenting the system as permanently fixed to a specific number of devices, Gantries, workstations, readers, sensors, printers, or handhelds.

Applied changes include:
- general operating/configuration instructions now use device roles such as **RFID reader**, **Gantry controller**, **direction sensor**, **RFID label printer**, **workstation**, and **handheld terminal** rather than hard-coding a particular hardware model;
- references to fixed Gantry/device quantities were removed from general procedures;
- end-to-end commissioning steps now apply to the configured/deployed site rather than assuming a fixed number of warehouses, Gantries, or routes;
- Dispatch documentation now refers to the RFID reader assigned to each Dispatch workstation while preserving the application rule of a single active local Checkout session per workstation;
- Handheld documentation describes supported RFID handheld hardware generically while preserving the actual application workflows;
- troubleshooting instructions now use the configured device/network values rather than hard-coded IP addresses;
- location-specific workflow instructions outside the default-rule reference were generalized to the configured source, destination, warehouse, receiving, and dispatch Locations;
- the **Integrated devices and purposes — reference deployment** section intentionally retains the supplied device-architecture models, quantities, and IP addresses as the current reference deployment;
- that section now clearly states that it is a deployment baseline, **not a fixed system limit**, and that additional Gantries, readers, sensors, controllers, handhelds, printers, workstations, and network devices can be added when properly configured;
- the default RFID-rule table retains its current reference-site routes because those rows describe the actual seeded/default rule set, with an added note that more Locations/routes can be configured.

No search sidebar, documentation light/dark toggle, or print feature was reintroduced.


## Approved-scope revision

The documentation was revised to match the currently approved and tested operating scope:

- removed the unapproved inter-warehouse movement rules and related procedures;
- removed the corresponding commissioning test;
- generalized the RFID-rule commissioning step so it refers only to approved processing, inbound and dispatch rules;
- retained Admin vs Viewer behavior as end-user guidance, but removed wording that suggests user-account role/permission configuration is available;
- replaced the Admin guide heading `Roles: Admin vs Viewer` with `Admin vs Viewer access`;
- replaced `Role` with `Account type` in that behavior table;
- removed role/permission wording from the commissioning checklist and troubleshooting guidance.

The Location `Location Role` field remains documented because it is a Location/master-data property, not user-account access configuration.


## Admin / Viewer access and Dashboard clarification

The end-user documentation now follows the approved deployment access model:

- the default web access model documents only **Admin** and **Viewer**;
- any additional legacy/development account scaffolding in source is outside the approved end-user scope and is not documented;
- Viewer behavior is defined as: **Performs warehouse Storage/Dispatch operations, monitors operational pages such as Dashboard, Assets, Locations, Devices, Scan Histories, Asset Movements and Alerts without changing configuration.**
- generic workflow instructions use `user`, `warehouse user`, or `recommended action` terminology;
- the System page uses a current text-based architecture summary so the documented account model remains consistent;
- the Dashboard chapter now explains the current operational summary components:
  Auto Refresh/manual Refresh, Quick Actions, Total Assets, Total Devices/Scanners,
  Total Locations, Total Racks, Unresolved Alerts, Assets by Location, Assets by Status,
  Devices by Location, Racks by Location, 30-day Scan Trends and Recent Scans.

This revision changes documentation scope and wording only; application source code is unchanged.

## Sectioned navigation and movement-planning revision

- Split the former Admin Web Guide into dedicated pages for Dashboard & Movement Planning, Asset Movements,
  Assets, Locations & Racks, Devices, System Settings and Administration.
- Reorganized the sidebar into Start here, Operate the system, Configure the system, Administration,
  Reference and Support, following the supplied reference documentation pattern.
- Renamed user-facing `inbound movement` wording to `Storage movement`.
- Corrected Dispatch movement planning: users select a Shipment ID, then `Warehouse From` displays the current
  Warehouse(s), Rack(s) and Asset counts for that Shipment; it is informational and not a Warehouse selector.
- Added Pending movement editing guidance with focused Storage and Dispatch edit screenshots.
- Removed `RFA630-101 antennas` from the integrated-device section.


## Device IP configuration method clarification

The documentation now explicitly states the approved IP-address configuration method:

- use **SICK SOPAS ET** to configure IP addresses for supported SICK network devices;
- configure **TDC-X controllers** by opening the TDC-X connection webpage in a web browser and adjusting the IP settings there;
- configure **PicoScan LiDAR devices** by opening the PicoScan connection webpage in a web browser and adjusting the IP settings there;
- configure third-party devices such as workstations, network infrastructure and the RFID label printer through their own configuration interfaces.

This clarification was added to Overview & Quick Start, End-to-End Setup, System/Devices & Network, the per-device checklist, and IP-related troubleshooting.

## Create-by-Shipment screenshot correction

The Assets guide now uses the original, uncropped `Create Assets by Shipment` screenshots from the supplied UI evidence:

- full form showing Shipment Assignment, printer selection and the first Asset row;
- full multi-row state showing additional Assets in the same Shipment batch.

The previous incorrectly cropped `assets-batch.jpg` image is no longer used.

## Device Login Password and Settings guide expansion

- Expanded the Devices guide to explain that **Device Login Password is the technical credential used by edge applications to get data from the Admin system and submit data to the Admin system**.
- Clarified that Device Login Password is separate from Admin/Viewer human-account passwords.
- Documented device authentication flow at a user-friendly level: Device identifier + Device Login Password → backend authentication → device tokens → permitted Admin API communication.
- Added commissioning guidance for generated/rotated Device Login Passwords and noted that the backend stores only a protected hash.
- Expanded the separate System Settings page to cover every current user-facing section:
  General, RFID Tag, Movement Validation, Data Retention and Security.
- Added purpose, source baseline/default values, operational effect, cautions and change guidance for every visible setting.
- Added all five full Settings screenshots from the supplied UI evidence.
- Clarified that the route-graph configuration is internal and not exposed as a normal editable end-user Settings control in the current UI.
- Distinguished human-account password rules from Device Login Password.

## Rack QR Word template and Handheld cleanup

- Added the supplied `P4 Rack QR Code A4.docx` file to the offline documentation package as
  `assets/downloads/P4_Rack_QR_Code_A4_Template.docx`.
- Added a direct download link and usage instructions to the Locations & Racks guide.
- Added a contextual download link to the Handheld Rack QR Search section.
- Clarified that the template examples must be replaced with the actual Rack QR generated in Admin Web before printing.
- Removed the Handheld `Installation reference` section and related APK-installation screenshot/reference.

## Full multi-page package verification

The final delivery package contains the complete documentation site, not only the Overview page.
It preserves all dedicated HTML pages and assets from the latest complete manual and includes the
Storage and Dispatch workflow diagrams on Overview & Quick Start.

## Whole-document readability and consistency review

All documentation pages were reviewed again for end-user readability and layout consistency.

Applied improvements:
- shortened long paragraphs and multi-clause instructions;
- replaced developer-oriented wording where a simpler operational term was sufficient;
- standardized page introductions, task steps, figure captions and footers;
- removed repetitive `Click image to enlarge` text from every figure caption while retaining image enlargement behavior;
- renamed duplicate headings such as `Assets → Manage Assets`, `Devices → Manage Devices`,
  `Locations and Racks → Manage Locations and Racks`, and `Asset Movements → Monitor Asset Movements`;
- standardized procedural ordered lists to the same numbered-step style;
- simplified Dashboard, movement, Handheld, Dispatch, Settings, network and troubleshooting explanations;
- changed `Source baseline` to `Default` in Settings tables for clearer end-user wording;
- clarified duplicate-safe/idempotent behavior using plain language while preserving the intended behavior;
- generalized the READY_FOR_DISPATCH description so it is not tied to a specific named exit;
- preserved the user-approved Admin/Viewer access description and approved Storage/Dispatch scope;
- added the same footer and content-spacing pattern to every page.

No workflow scope, RFID rule intent, Alert rule intent, default value, or deployment-specific instruction was intentionally changed by this editorial review.


## Screenshot coverage enhancement

Reviewed the complete documentation against `p4-system-ui-screenshots(2).zip`. Added 20 original, uncropped UI screenshots at the exact task sections where visual confirmation improves the instructions. Existing user-modified content was preserved. No APK-installation or Security-settings screenshots were reintroduced.
