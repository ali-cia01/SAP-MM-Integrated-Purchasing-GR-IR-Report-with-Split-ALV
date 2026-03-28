# 📦 [MM] Goods Receipt Management Report

![SAP](https://img.shields.io/badge/SAP-ERP-blue?style=flat-square&logo=sap)
![Module](https://img.shields.io/badge/Module-MM-green?style=flat-square)
![Type](https://img.shields.io/badge/Type-ALV%20Report-orange?style=flat-square)
![BAPI](https://img.shields.io/badge/BAPI-GOODSMVT__CREATE%20%7C%20CANCEL-red?style=flat-square)

---

## 📌 Overview

A custom SAP MM report that integrates **Purchase Order (PO) data**, **Goods Receipt (GR) processing**, and **Invoice Verification (IV)** status into a single unified screen.

- Displays PO data across multiple ALV views simultaneously
- Enables GR creation and cancellation via BAPI
- Provides Document Flow inquiry via Tabstrip popup

---

## 🗂️ Screen Layout
```
┌─────────────────────────────────────────────────────┐
│                   Selection Screen                  │
└─────────────────────────┬───────────────────────────┘
                          │
          ┌───────────────┴───────────────┐
          ▼                               ▼
   ┌─────────────┐                ┌──────────────────┐
   │    TAB 1    │                │      TAB 2       │
   │  ALV_PO     │                │  ALV_VENDOR      │
   │  (PO-based) │                │  ALV_MATERIAL    │
   └──────┬──────┘                │  (Split ALV)     │
          │                       └──────────────────┘
          ▼
   ┌──────────────────────────┐
   │   Popup Subscreen        │
   │   (Tabstrip: TAB1, TAB2) │
   └──────────────────────────┘
```

---

## 🔍 1. Selection Screen

**Block: Purchasing Processing Info.**

| Field | Reference | Required | Notes |
|---|---|:---:|---|
| Company | `EKPO-BUKRS` | ✅ | No Interval |
| Plant | `EKPO-WERKS` | | Range |
| Material | `EKPO-MATNR` | | Range |
| Vendor | `EKKO-LIFNR` | | Range |
| Purchase Order | `EKPO-EBELN` | | Range |
| Purchase Org. | `EKKO-EKORG` | | Range |
| Purchase Group | `EKKO-EKGRP` | | Range |
| Item Category | `EKPO-PSTYP` | | Range |
| AAC | `EKPO-KNTTP` | | Range |
| Include Deletion | — | | Checkbox |

---

## 📊 2. ALV1 — PO-Based List (`ALV_PO`)

### Output Fields

| Field | Reference | Description |
|---|---|---|
| Checkbox | — | Row selection for button actions |
| Status | N/A | 🟢 GR & IV complete / 🟡 Either complete / 🔴 Neither |
| PO Num. | `EKPO-EBELN` | Hotspot → PO document |
| Item | `EKPO-EBELP` | |
| Pur. Req. | `EBAN-BANFN` | Double-click → PR document |
| Vendor | `EKKO-LIFNR` | Double-click → Vendor master |
| Material | `EKPO-MATNR` | Hotspot → Material document |
| Material Description | `MAKT-MAKTX` | Language: `SY-LANGU` |
| Plant | `EKPO-WERKS` | |
| Storage Location | `EKPO-LGORT` | |
| PO Qty | `EKPO-MENGE` | |
| Open PO Qty | Calculated | PO Qty − GR Qty |
| Unit | `EKPO-MEINS` | |
| Net Price | `EKPO-NETPR` | |
| Currency | `EKKO-WAERS` | |
| GR Doc | `EKBE-BELNR` | Multi-icon → Double-click for Doc. Flow |
| GR Year | `EKBE-GJAHR` | |
| GR Qty | `EKBE-MENGE` | Negative if `EKBE-SHKZG = 'H'` |
| GR Amount | `EKBE-DMBTR` | |
| IV Doc. | `EKBE-BELNR` | `VGABE = 2` in EKBE |
| IV Year | `EKBE-GJAHR` | |
| IV Amount | `EKBE-DMBTR` | |

> **Note:** In `EKBE`, `VGABE = 1` → Goods Receipt / `VGABE = 2` → Invoice Verification

---

### ⚙️ Application Buttons

#### 📥 GR Processing — `BAPI_GOODSMVT_CREATE`

> Only **one checkbox row** may be selected. Multiple selections trigger an error message.

| Structure/Table | Field | Description | Value |
|---|---|---|---|
| `GOODSMVT_HEADER` | `PSTNG_DATE` | Posting Date | From popup |
| | `DOC_DATE` | Document Date | `SY-DATUM` |
| | `REF_DOC_NO` | Reference No. | ALV input |
| `GOODSMVT_CODE` | `GM_CODE` | GM Code | `01` |
| `GOODSMVT_ITEM` | `MATERIAL` | Material | Selected row |
| | `MOVE_TYPE` | Movement Type | `101` |
| | `PO_NUMBER` | PO Number | Selected row |
| | `PO_ITEM` | PO Item | Selected row |
| | `MVT_IND` | Movement Indicator | `B` |

**On Success:** Success message displayed → GR document number updated in ALV → Row style reset

#### ❌ GR Cancellation — `BAPI_GOODSMVT_CANCEL`

| Structure/Table | Field | Description | Value |
|---|---|---|---|
| `GOODSMVT_ITEM` | `MATERIALDOCUMENT` | Material Document | From selected row |
| | `MATDOCUMENTYEAR` | Document Year | From selected row |

---

### 📄 ALV Button — Document Flow (`Doc Flow`)

> Only **one checkbox row** may be selected. Multiple selections trigger an error message.

- Opens a **Tabstrip popup** with GR and IV details for the selected PO line
- If GR Doc shows a **multi-icon**, clicking that row opens an additional **ALV popup** listing all Doc Flows

| TAB1 — GR Info | TAB2 — IV Info |
|---|---|
| Purchasing No. | Purchasing No. |
| Item | Item |
| GR Doc | IV Doc |
| Year | Year |
| GR Qty | — |
| GR Amount | IV Amount |

---

## 📊 3. ALV2 — Vendor & Material Summary (Split ALV)

Two ALV instances displayed **simultaneously** within a single screen area using **Split ALV**.

### ALV BY Vendor

| Field | Description |
|---|---|
| Vendor | Vendor code |
| Name | Vendor name |
| PO Quantity | Total PO quantity |
| Open PO Qty | Remaining open quantity |
| PO Amount | Total PO amount |
| GR Qty | Total GR quantity |
| GR Amount | Total GR amount |
| IV Amount | Total IV amount |

### ALV BY Material

| Field | Description |
|---|---|
| Material | Material code |
| Material Description | Material description |
| PO Quantity | Total PO quantity |
| Open PO Qty | Remaining open quantity |
| PO Amount | Total PO amount |
| GR Qty | Total GR quantity |
| GR Amount | Total GR amount |
| IV Amount | Total IV amount |

> Field references are identical to ALV1.

---

## ✅ Key Features

| Feature | Description |
|---|---|
| Dual ALV Display | ALV1 (PO view) + ALV2 (Vendor/Material view) on one screen |
| Split ALV | Vendor & Material summaries side by side |
| GR Processing | Create GR via `BAPI_GOODSMVT_CREATE` (Movement Type 101) |
| GR Cancellation | Cancel GR via `BAPI_GOODSMVT_CANCEL` |
| Doc Flow Popup | Tabstrip popup showing GR & IV document details |
| Navigation | Hotspot/Double-click to PO, PR, Vendor, Material master |
| Status Indicator | Traffic light for GR/IV completion status |

---

## 📁 Related SAP Tables

| Table | Description |
|---|---|
| `EKKO` | Purchasing document header |
| `EKPO` | Purchasing document item |
| `EBAN` | Purchase requisition |
| `EKBE` | Purchasing document history (GR/IV) |
| `MAKT` | Material descriptions |
| `LFA1` | Vendor master — general data |
