*&---------------------------------------------------------------------*
*&  Include           YFDMM_04_TOP
*&---------------------------------------------------------------------*
REPORT yfdmm_04.

TYPE-POOLS: icon.
DATA: ok_code TYPE sy-ucomm.
TABLES: ekpo, ekko.

SELECTION-SCREEN BEGIN OF BLOCK condition WITH FRAME TITLE text-001.
SELECT-OPTIONS: so_bukrs FOR ekpo-bukrs NO-EXTENSION NO INTERVALS MODIF ID cp MEMORY ID cp,
                so_werks FOR ekpo-werks,
                so_matnr FOR ekpo-matnr,
                so_lifnr FOR ekko-lifnr,
                so_ebeln FOR ekpo-ebeln,
                so_ekorg FOR ekko-ekorg,
                so_ekgrp FOR ekko-ekgrp,
                so_pstyp FOR ekpo-pstyp,
                so_knttp FOR ekpo-knttp.
SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN ULINE.
PARAMETERS: deletion AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK condition.

DATA: go_container1 TYPE REF TO cl_gui_custom_container,
      go_container2 TYPE REF TO cl_gui_custom_container.
DATA: go_container_gr TYPE REF TO cl_gui_custom_container.

DATA: go_splitter    TYPE REF TO cl_gui_splitter_container,
      go_cell_top    TYPE REF TO cl_gui_container,
      go_cell_bottom TYPE REF TO cl_gui_container.

DATA: go_grid1 TYPE REF TO cl_gui_alv_grid,
      go_grid2 TYPE REF TO cl_gui_alv_grid,
      go_grid3 TYPE REF TO cl_gui_alv_grid.
DATA: go_grid_gr      TYPE REF TO cl_gui_alv_grid.

DATA: gt_fcat TYPE lvc_t_fcat,
      gs_fcat TYPE lvc_s_fcat.

DATA: gt_fcat_vendor TYPE lvc_t_fcat,
      gs_fcat_vendor TYPE lvc_s_fcat.

DATA: gt_fcat_material TYPE lvc_t_fcat,
      gs_fcat_material TYPE lvc_s_fcat.

DATA: gt_fcat_gr TYPE lvc_t_fcat,
      gs_fcat_gr TYPE lvc_s_fcat.

"이건 하나만 쓰면서 그냥 clear해주기
DATA: gs_layout TYPE lvc_s_layo.

DATA: gt_sort TYPE lvc_t_sort,
      gs_sort TYPE lvc_s_sort.

DATA: gt_sort2 TYPE lvc_t_sort,
      gs_sort2 TYPE lvc_s_sort.

DATA: gt_sort3 TYPE lvc_t_sort,
      gs_sort3 TYPE lvc_s_sort.

CONTROLS: tab_ctl TYPE TABSTRIP.
DATA: gv_subs TYPE sy-dynnr. "서브스크린 번호 담아주는 변수

" alv1에서 뿌릴 데이터 선언
TYPES: BEGIN OF ty_display,
         status      TYPE c LENGTH 4,
         loekz       TYPE ekpo-loekz,
         banfn       TYPE eban-banfn,
         bnfpo       TYPE eban-bnfpo,
         ebeln       TYPE ekpo-ebeln,
         ebelp       TYPE ekpo-ebelp,
         lifnr       TYPE ekko-lifnr,
         name1       TYPE lfa1-name1,
         matnr       TYPE ekpo-matnr,
         maktx       TYPE makt-maktx,
         werks       TYPE ekpo-werks,
         lgort       TYPE ekpo-lgort,
         menge       TYPE ekpo-menge,
         open_po_qty TYPE ekpo-menge,
         gr_proc_qty TYPE ekpo-menge,
         meins       TYPE ekpo-meins,
         netpr       TYPE ekpo-netpr,
         waers       TYPE ekko-waers,
         gr_belnr    TYPE c LENGTH 20,
         gr_gjahr    TYPE ekbe-gjahr,
         gr_bwart    TYPE ekbe-bwart,
         gr_menge    TYPE ekbe-menge,
         gr_dmbtr    TYPE ekbe-dmbtr,
         iv_belnr    TYPE ekbe-belnr,
         iv_gjahr    TYPE ekbe-gjahr,
         iv_dmbtr    TYPE ekbe-dmbtr,
       END OF ty_display.
DATA: gs_display TYPE ty_display,
      gt_display LIKE TABLE OF gs_display.

DATA: lr_loekz TYPE RANGE OF ekpo-loekz,
      ls_loekz LIKE LINE OF lr_loekz.

DATA: gt_ekbe TYPE TABLE OF ekbe,
      gs_ekbe TYPE ekbe.
DATA: gr_d_cnt TYPE i.

"ALV BY Vendor
TYPES: BEGIN OF ty_vendor,
         lifnr    TYPE ekko-lifnr,
         name1    TYPE lfa1-name1,
         menge    TYPE p LENGTH 13 DECIMALS 3,   " PO Quantity
         open_po  TYPE p LENGTH 13 DECIMALS 3,   " Open PO Q'ty
         netwr    TYPE p LENGTH 13 DECIMALS 2,   " PO Amount
         gr_menge TYPE p LENGTH 13 DECIMALS 3,   " GR Q'TY
         gr_dmbtr TYPE p LENGTH 13 DECIMALS 2,   " GR Amount
         iv_dmbtr TYPE p LENGTH 13 DECIMALS 2,   " IV Amount
       END OF ty_vendor.
DATA: gt_vendor TYPE TABLE OF ty_vendor,
      gs_vendor TYPE ty_vendor.

TYPES: BEGIN OF ty_material,
         matnr    TYPE ekpo-matnr,
         maktx    TYPE makt-maktx,
         menge    TYPE p LENGTH 13 DECIMALS 3,   " PO Quantity
         open_po  TYPE p LENGTH 13 DECIMALS 3,   " Open PO Q'ty
         netwr    TYPE p LENGTH 13 DECIMALS 2,   " PO Amount
         gr_menge TYPE p LENGTH 13 DECIMALS 3,   " GR Q'TY
         gr_dmbtr TYPE p LENGTH 13 DECIMALS 2,   " GR Amount
         iv_dmbtr TYPE p LENGTH 13 DECIMALS 2,   " IV Amount
       END OF ty_material.
DATA:       gt_material TYPE TABLE OF ty_material,
            gs_material TYPE ty_material.


TYPES: BEGIN OF ty_gr_doc,
         ebeln TYPE ekpo-ebeln,   " Purchasing No
         ebelp TYPE ekpo-ebelp,   " Item
         belnr TYPE ekbe-belnr,   " GR Doc
         gjahr TYPE ekbe-gjahr,   " Year
         menge TYPE ekbe-menge,   " GR QTY
         dmbtr TYPE ekbe-dmbtr,   " GR Amount
       END OF ty_gr_doc.

DATA: gt_gr_doc TYPE TABLE OF ty_gr_doc,
      gs_gr_doc TYPE ty_gr_doc.


" data for bapi
"creation
  DATA: gv_pstng_date TYPE sy-datum. "전기일
  DATA: lv_answer TYPE c LENGTH 1.
  DATA: lt_row_no  TYPE lvc_t_roid.
  DATA: ls_row_no  TYPE lvc_s_roid.
  DATA: ls_header  TYPE bapi2017_gm_head_01.
  DATA: ls_code    TYPE bapi2017_gm_code.
  DATA: lt_item    TYPE TABLE OF bapi2017_gm_item_create.
  DATA: ls_item    TYPE bapi2017_gm_item_create.
  DATA: ls_headret TYPE bapi2017_gm_head_ret.
  DATA: lt_return  TYPE TABLE OF bapiret2.
  DATA: ls_return  TYPE bapiret2.
  DATA: lt_fields  TYPE TABLE OF sval.
  DATA: ls_fields  TYPE sval.

  "deletion
  DATA: lv_mat_doc  TYPE bapi2017_gm_head_ret-mat_doc.
  DATA: lv_mat_year TYPE bapi2017_gm_head_ret-doc_year.
