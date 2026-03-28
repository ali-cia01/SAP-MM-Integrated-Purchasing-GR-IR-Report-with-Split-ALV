# 📦 [MM] Integrated Purchasing & GR/IR Report with Split ALV

> **SAP MM Module | ABAP Report**
> [cite_start]A comprehensive tracking report for the purchasing process (PO → GR → IR) featuring real-time BAPI integration and multi-perspective Split ALV layouts[cite: 1, 6, 7].

---

## 📌 Overview

[cite_start]This ABAP program provides a centralized dashboard to monitor the entire lifecycle of a Purchase Order, from initial requisition to final invoice verification[cite: 1, 6]. [cite_start]It utilizes a **Split ALV** interface to present both granular line-item details and aggregated summaries (by Vendor and Material) on a single screen[cite: 6, 349, 351, 360]. 

[cite_start]A key feature is the direct integration with SAP BAPIs, allowing users to perform Goods Receipt (GR) postings or cancellations directly from the ALV grid[cite: 7, 176, 194, 195].

---

## ✨ Key Features

* [cite_start]**Integrated Monitoring:** Tracks the status of PO, GR, and IR in one view[cite: 1, 6].
* **Visual Status Indicators:** Uses traffic light icons to represent processing stages:
    * [cite_start]🟢 **Green:** Both GR and IR are completed[cite: 113].
    * [cite_start]🟡 **Yellow:** Either GR or IR is completed[cite: 113].
    * [cite_start]🔴 **Red:** Neither GR nor IR is completed[cite: 113].
* **Real-time BAPI Processing:**
    * [cite_start]**GR Creation:** Executes `BAPI_GOODSMVT_CREATE` for selected lines[cite: 7, 194, 269].
    * [cite_start]**GR Cancellation:** Executes `BAPI_GOODSMVT_CANCEL` for selected lines[cite: 7, 195, 270].
* [cite_start]**Split ALV Implementation:** Displays two independent ALV instances simultaneously; one for main data and another split into Vendor/Material summaries[cite: 6, 24, 349, 351, 360].
* [cite_start]**Detailed Document Flow:** A dedicated "Doc Flow" button triggers a popup with **Tabstrip** controls to view specific GR and IR history for a selected item[cite: 8, 20, 296].
* [cite_start]**Navigation (Hotspots):** Support for double-click navigation to standard transactions like `ME23N` (PO), `ME53N` (PR), and Vendor/Material master data[cite: 116, 121, 126, 131].

---

## 🖥️ Selection Screen

| Field | SAP Reference | Required | Note |
| :--- | :--- | :---: | :--- |
| Company Code | EKPO-BUKRS | ✅ | [cite_start]No intervals allowed [cite: 50, 51, 52] |
| Plant | EKPO-WERKS | [cite_start]✅ | [cite: 53] |
| Material | EKPO-MATNR | [cite_start]| [cite: 54] |
| Vendor | EKKO-LIFNR | [cite_start]| [cite: 55] |
| Purchase Order | EKPO-EBELN | [cite_start]| [cite: 56] |
| Purchasing Organization | EKKO-EKORG | [cite_start]| [cite: 57] |
| Purchasing Group | EKKO-EKGRP | [cite_start]| [cite: 58] |
| Item Category | EKPO-PSTYP | [cite_start]| [cite: 59] |
| Account Assignment Cat. | EKPO-KNTTP | [cite_start]| [cite: 60] |

---

## 📊 Output Layouts

### 1. ALV1: Main PO Detail List
[cite_start]This primary grid displays detailed PO items and their corresponding GR/IR status[cite: 23, 62].
* [cite_start]**Open PO Quantity:** Calculated as `PO Quantity - GR Quantity`[cite: 141, 143].
* [cite_start]**GR Processing Qty:** Input field for specifying the quantity to be posted via BAPI (defaulted to Open PO Qty)[cite: 144, 146].
* [cite_start]**History Tracking:** Displays the most recent GR/IV document numbers and total accumulated amounts[cite: 83, 85, 86, 87, 89, 96, 100].

### 2. ALV2: Split Summary View
[cite_start]Implements `CL_GUI_SPLITTER_CONTAINER` to show two summary tables at the bottom of the screen[cite: 24, 349, 371].
* [cite_start]**[ALV BY Vendor]:** Summarizes PO Qty, Open Qty, PO Amount, GR Qty, and GR/IR Amounts per Vendor[cite: 351, 352, 354, 355, 356, 357, 358, 359].
* [cite_start]**[ALV BY Material]:** Summarizes the same metrics grouped by Material[cite: 360, 361, 363, 364, 365, 366, 367, 368].

---

## ⚙️ Technical Details

### BAPI Integration Parameters
* [cite_start]**GR Posting:** Uses `GM_CODE` '01' and `MOVE_TYPE` '101'[cite: 219, 226, 269].
* [cite_start]**Negative Sign Handling:** For return deliveries or cancellations (`SHKZG` = 'H'), the quantities and amounts are displayed with a negative sign[cite: 165].

### Popup Screen (Document Flow)
* [cite_start]**TAB1 (GR Info):** Shows Purchase No, Item, GR Document, Year, Qty, and Amount[cite: 297, 299, 301, 303, 305, 307, 309].
* [cite_start]**TAB2 (IV Info):** Shows Purchase No, Item, IV Document, Year, and Amount[cite: 312, 313, 315, 317, 319, 321].

---

## 🗂️ SAP Tables Referenced

| Table | Description | Key Fields Used |
| :--- | :--- | :--- |
| **EKKO / EKPO** | PO Header / Item | [cite_start]EBELN, EBELP, BUKRS, WERKS, MATNR, LIFNR [cite: 50, 53, 54, 55, 56, 120] |
| **EKBE** | PO History | [cite_start]BELNR, GJAHR, VGABE (1=GR, 2=IR), SHKZG [cite: 157, 160, 165, 168, 175] |
| **EBAN** | Purchase Requisition | [cite_start]BANFN, BNFPO [cite: 115, 118] |
| **LFA1** | Vendor Master | [cite_start]LIFNR, NAME1 [cite: 125, 128] |
| **MAKT** | Material Description | [cite_start]MATNR, MAKTX [cite: 130, 133] |
| **BSEG** | Accounting Document | [cite_start]BELNR, WRBTR [cite: 166, 167] |

---

## 🛠️ Development Environment

* [cite_start]**Module:** SAP MM (Materials Management) 
* [cite_start]**Language:** ABAP 
* [cite_start]**UI Components:** * Selection Screen [cite: 3, 26]
    * [cite_start]ALV Grid (`CL_GUI_ALV_GRID`) [cite: 6, 23, 24]
    * [cite_start]Splitter Container (`CL_GUI_SPLITTER_CONTAINER`) [cite: 6, 349]
    * [cite_start]Tabstrip Control (Screen 0100/0200) [cite: 12, 296]

---
[cite_start]*This report was developed to optimize the Purchasing Officer's workflow by automating GR entries and providing instant data reconciliation[cite: 5, 7, 8].*
