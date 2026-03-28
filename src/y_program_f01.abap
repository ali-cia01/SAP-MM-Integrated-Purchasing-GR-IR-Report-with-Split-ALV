*&---------------------------------------------------------------------*
*&  Include           YFDMM_04_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  INPUT_CHECK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM input_check.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  MODIFY_SCREEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM modify_screen .
  LOOP AT SCREEN.
    IF screen-group1 = 'CP'.
      screen-intensified = '1'.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  START_OF_SELECTION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM start_of_selection .
  "< master data>"
  PERFORM get_data1.
  "<sub data>"
  PERFORM get_sub_data.
  "<alv 2 data>'
  PERFORM get_alv2_data.

  IF gt_display IS NOT INITIAL.
    CALL SCREEN 200.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_fcat.
  CLEAR: gs_fcat, gt_fcat.

  " Status - 틀고정
  gs_fcat-fieldname = 'STATUS'.
  gs_fcat-coltext   = 'Status'.
  gs_fcat-fix_column = 'X'.
  gs_fcat-icon      = 'X'.
  APPEND gs_fcat TO gt_fcat. CLEAR gs_fcat.


  gs_fcat-fieldname = 'LOEKZ'.
  gs_fcat-coltext   = 'Deletion'.      
  gs_fcat-fix_column = 'X'.
  IF deletion = 'X'.
    gs_fcat-no_out = ' '.   " 보임
  ELSE.
    gs_fcat-no_out = 'X'.   " 숨김
  ENDIF.
  APPEND gs_fcat TO gt_fcat. CLEAR gs_fcat.

  " Purchase Requisition - 틀고정
  gs_fcat-fieldname = 'BANFN'.
  gs_fcat-coltext   = 'Purchase Requisition'.
  gs_fcat-fix_column = 'X'.
  gs_fcat-hotspot   = 'X'.
  APPEND gs_fcat TO gt_fcat. CLEAR gs_fcat.

  " Item - 틀고정
  gs_fcat-fieldname = 'BNFPO'.
  gs_fcat-coltext   = 'Item'.
  gs_fcat-fix_column = 'X'.
  APPEND gs_fcat TO gt_fcat. CLEAR gs_fcat.

  " Purchasing No - 틀고정
  gs_fcat-fieldname = 'EBELN'.
  gs_fcat-coltext   = 'Purchasing No.'.
  gs_fcat-fix_column = 'X'.
  gs_fcat-hotspot   = 'X'.
  APPEND gs_fcat TO gt_fcat. CLEAR gs_fcat.

  " Item - 틀고정
  gs_fcat-fieldname = 'EBELP'.
  gs_fcat-coltext   = 'Item'.
  gs_fcat-fix_column = 'X'.
  APPEND gs_fcat TO gt_fcat. CLEAR gs_fcat.

  " Vendor - 틀고정
  gs_fcat-fieldname = 'LIFNR'.
  gs_fcat-coltext   = 'Vendor'.
  gs_fcat-fix_column = 'X'.
  gs_fcat-hotspot   = 'X'.
  APPEND gs_fcat TO gt_fcat. CLEAR gs_fcat.

  " Name - 틀고정
  gs_fcat-fieldname = 'NAME1'.
  gs_fcat-coltext   = 'Name'.
  gs_fcat-fix_column = 'X'.
  APPEND gs_fcat TO gt_fcat. CLEAR gs_fcat.

  " Material
  gs_fcat-fieldname = 'MATNR'.
  gs_fcat-coltext   = 'Material'.
  gs_fcat-hotspot   = 'X'.
  APPEND gs_fcat TO gt_fcat. CLEAR gs_fcat.

  " Material Description
  gs_fcat-fieldname = 'MAKTX'.
  gs_fcat-coltext   = 'Material Description'.
  APPEND gs_fcat TO gt_fcat. CLEAR gs_fcat.

  " Plant
  gs_fcat-fieldname = 'WERKS'.
  gs_fcat-coltext   = 'Plant'.
  APPEND gs_fcat TO gt_fcat. CLEAR gs_fcat.

  " Storage Location
  gs_fcat-fieldname = 'LGORT'.
  gs_fcat-coltext   = 'Storage Location'.
  APPEND gs_fcat TO gt_fcat. CLEAR gs_fcat.

  " PO Quantity
  gs_fcat-fieldname = 'MENGE'.
  gs_fcat-coltext   = 'PO Quantity'.
  APPEND gs_fcat TO gt_fcat. CLEAR gs_fcat.

  " Open PO Qty
  gs_fcat-fieldname = 'OPEN_PO_QTY'.
  gs_fcat-coltext   = 'Open PO Qty'.
  APPEND gs_fcat TO gt_fcat. CLEAR gs_fcat.

  " GR Processing Qty
  gs_fcat-fieldname = 'GR_PROC_QTY'.
  gs_fcat-coltext   = 'GR Processing Qty'.
  gs_fcat-edit      = 'X'.
  APPEND gs_fcat TO gt_fcat. CLEAR gs_fcat.

  " Unit
  gs_fcat-fieldname = 'MEINS'.
  gs_fcat-coltext   = 'Unit'.
  APPEND gs_fcat TO gt_fcat. CLEAR gs_fcat.

  " Net Price
  gs_fcat-fieldname = 'NETPR'.
  gs_fcat-coltext   = 'Net Price'.
  APPEND gs_fcat TO gt_fcat. CLEAR gs_fcat.

  " Currency
  gs_fcat-fieldname = 'WAERS'.
  gs_fcat-coltext   = 'Currency'.
  APPEND gs_fcat TO gt_fcat. CLEAR gs_fcat.

  " GR Doc
  gs_fcat-fieldname = 'GR_BELNR'.
  gs_fcat-coltext   = 'GR Doc'.
  "gs_fcat-icon = 'X'.
  APPEND gs_fcat TO gt_fcat. CLEAR gs_fcat.

  " GR Year
  gs_fcat-fieldname = 'GR_GJAHR'.
  gs_fcat-coltext   = 'Year'.
  APPEND gs_fcat TO gt_fcat. CLEAR gs_fcat.

  " Movement Type
  gs_fcat-fieldname = 'GR_BWART'.
  gs_fcat-coltext   = 'Movement Type'.
  APPEND gs_fcat TO gt_fcat. CLEAR gs_fcat.

  " GR Qty
  gs_fcat-fieldname = 'GR_MENGE'.
  gs_fcat-coltext   = 'GR Q''TY'.
  APPEND gs_fcat TO gt_fcat. CLEAR gs_fcat.

  " GR Amount
  gs_fcat-fieldname = 'GR_DMBTR'.
  gs_fcat-coltext   = 'GR Amount'.
  APPEND gs_fcat TO gt_fcat. CLEAR gs_fcat.

  " IV Doc
  gs_fcat-fieldname = 'IV_BELNR'.
  gs_fcat-coltext   = 'IV Doc.'.
  APPEND gs_fcat TO gt_fcat. CLEAR gs_fcat.

  " IV Year
  gs_fcat-fieldname = 'IV_GJAHR'.
  gs_fcat-coltext   = 'Year'.
  APPEND gs_fcat TO gt_fcat. CLEAR gs_fcat.

  " IV Amount
  gs_fcat-fieldname = 'IV_DMBTR'.
  gs_fcat-coltext   = 'IV Amount'.
  APPEND gs_fcat TO gt_fcat. CLEAR gs_fcat.

  gs_sort-fieldname = 'EBELN'.
  gs_sort-up = 'X'.
  gs_sort-spos = 1.
  APPEND gs_sort TO gt_sort.

  gs_layout-sel_mode = 'D'.
  gs_layout-grid_title  = '[ ALV BY PO ]'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_FCAT_ALV2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_fcat_alv2 .

  gs_fcat_vendor-fieldname = 'LIFNR'.
  gs_fcat_vendor-coltext = 'Vendor'.
  APPEND gs_fcat_vendor TO gt_fcat_vendor.
  CLEAR gs_fcat_vendor.

  gs_fcat_vendor-fieldname = 'NAME1'.
  gs_fcat_vendor-coltext = 'Name'.
  APPEND gs_fcat_vendor TO gt_fcat_vendor.
  CLEAR gs_fcat_vendor.

  gs_fcat_vendor-fieldname = 'MENGE'.
  gs_fcat_vendor-coltext = 'PO Quantity'.
  APPEND gs_fcat_vendor TO gt_fcat_vendor.
  CLEAR gs_fcat_vendor.

  gs_fcat_vendor-fieldname = 'OPEN_PO'.
  gs_fcat_vendor-coltext = 'Open PO Q''ty'.
  APPEND gs_fcat_vendor TO gt_fcat_vendor.
  CLEAR gs_fcat_vendor.

  gs_fcat_vendor-fieldname = 'NETWR'.
  gs_fcat_vendor-coltext = 'PO Amount'.
  APPEND gs_fcat_vendor TO gt_fcat_vendor.
  CLEAR gs_fcat_vendor.

  gs_fcat_vendor-fieldname = 'GR_MENGE'.
  gs_fcat_vendor-coltext = 'GR Q''TY'.
  APPEND gs_fcat_vendor TO gt_fcat_vendor.
  CLEAR gs_fcat_vendor.

  gs_fcat_vendor-fieldname = 'GR_DMBTR'.
  gs_fcat_vendor-coltext = 'GR Amount'.
  APPEND gs_fcat_vendor TO gt_fcat_vendor.
  CLEAR gs_fcat_vendor.

  gs_fcat_vendor-fieldname = 'IV_DMBTR'.
  gs_fcat_vendor-coltext = 'IV Amount'.
  APPEND gs_fcat_vendor TO gt_fcat_vendor.

  gs_sort2-fieldname = 'LIFNR'.
  gs_sort2-up        = 'X'.
  gs_sort2-spos      = 1.
  APPEND gs_sort2 TO gt_sort2.

  CLEAR gs_layout.
  gs_layout-grid_title  = '[ ALV BY Vendor ]'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_FCAT_ALV3
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_fcat_alv3 .

  gs_fcat_material-fieldname = 'MATNR'.
  gs_fcat_material-coltext = 'Material'.
  APPEND gs_fcat_material TO gt_fcat_material.
  CLEAR gs_fcat_material.

  gs_fcat_material-fieldname = 'MAKTX'.
  gs_fcat_material-coltext = 'Material description'.
  APPEND gs_fcat_material TO gt_fcat_material.
  CLEAR gs_fcat_material.

  gs_fcat_material-fieldname = 'MENGE'.
  gs_fcat_material-coltext = 'PO Quantity'.
  APPEND gs_fcat_material TO gt_fcat_material.
  CLEAR gs_fcat_material.

  gs_fcat_material-fieldname = 'OPEN_PO'.
  gs_fcat_material-coltext = 'Open PO Q''ty'.
  APPEND gs_fcat_material TO gt_fcat_material.
  CLEAR gs_fcat_material.

  gs_fcat_material-fieldname = 'NETWR'.
  gs_fcat_material-coltext = 'PO Amount'.
  APPEND gs_fcat_material TO gt_fcat_material.
  CLEAR gs_fcat_material.

  gs_fcat_material-fieldname = 'GR_MENGE'.
  gs_fcat_material-coltext = 'GR Q''TY'.
  APPEND gs_fcat_material TO gt_fcat_material.
  CLEAR gs_fcat_material.

  gs_fcat_material-fieldname = 'GR_DMBTR'.
  gs_fcat_material-coltext = 'GR Amount'.
  APPEND gs_fcat_material TO gt_fcat_material.
  CLEAR gs_fcat_material.

  gs_fcat_material-fieldname = 'IV_DMBTR'.
  gs_fcat_material-coltext = 'IV Amount'.
  APPEND gs_fcat_material TO gt_fcat_material.

  gs_sort3-fieldname = 'MATNR'.
  gs_sort3-up        = 'X'.
  gs_sort3-spos      = 1.
  APPEND gs_sort3 TO gt_sort3.

  CLEAR gs_layout.
  gs_layout-grid_title = '[ ALV BY Material ]'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  HANDLE_DOC_FLOW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM handle_doc_flow .
  DATA: lt_index_rows TYPE lvc_t_row,    
        ls_index_rows TYPE lvc_s_row.   


  CALL METHOD go_grid1->get_selected_rows
    IMPORTING
      et_index_rows = lt_index_rows.    

  IF lt_index_rows IS INITIAL.
    MESSAGE '조회할 항목을 선택하세요.' TYPE 'I'.
    RETURN.
  ENDIF.


  READ TABLE lt_index_rows INTO ls_index_rows INDEX 1.

  READ TABLE gt_display INTO gs_display INDEX ls_index_rows-index.

  IF sy-subrc <> 0.
    MESSAGE '선택한 행 데이터를 찾을 수 없습니다.' TYPE 'I'.
    RETURN.
  ENDIF.

  CALL SCREEN 300 STARTING AT 10 5
                  ENDING   AT 100 25.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_FCAT_GR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_fcat_gr .
  gs_fcat_gr-fieldname = 'EBELN'.
  gs_fcat_gr-coltext = 'Purchasing No'.
  APPEND gs_fcat_gr TO gt_fcat_gr.
  CLEAR gs_fcat_gr.

  gs_fcat_gr-fieldname = 'EBELP'.
  gs_fcat_gr-coltext = 'Item'.
  APPEND gs_fcat_gr TO gt_fcat_gr.
  CLEAR gs_fcat_gr.

  gs_fcat_gr-fieldname = 'BELNR'.
  gs_fcat_gr-coltext = 'GR Doc'.
  APPEND gs_fcat_gr TO gt_fcat_gr.
  CLEAR gs_fcat_gr.

  gs_fcat_gr-fieldname = 'GJAHR'.
  gs_fcat_gr-coltext = 'Year'.
  APPEND gs_fcat_gr TO gt_fcat_gr.
  CLEAR gs_fcat_gr.

  gs_fcat_gr-fieldname = 'MENGE'.
  gs_fcat_gr-coltext = 'GR QTY'.
  APPEND gs_fcat_gr TO gt_fcat_gr.
  CLEAR gs_fcat_gr.

  gs_fcat_gr-fieldname = 'DMBTR'.
  gs_fcat_gr-coltext = 'GR Amount'.
  APPEND gs_fcat_gr TO gt_fcat_gr.
  CLEAR gs_fcat_gr.

  CLEAR gs_layout.
  gs_layout-grid_title = '[ multiple documents info ]'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SETTING_VENDOR_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM setting_vendor_data .
  READ TABLE gt_vendor INTO gs_vendor
    WITH KEY lifnr = gs_display-lifnr.


  IF sy-subrc = 0.
    gs_vendor-menge    = gs_vendor-menge    + gs_display-menge.
    gs_vendor-open_po  = gs_vendor-open_po  + gs_display-open_po_qty.
    gs_vendor-gr_menge = gs_vendor-gr_menge + gs_display-gr_menge.
    gs_vendor-gr_dmbtr = gs_vendor-gr_dmbtr + gs_display-gr_dmbtr.
    gs_vendor-iv_dmbtr = gs_vendor-iv_dmbtr + gs_display-iv_dmbtr.
    MODIFY gt_vendor FROM gs_vendor INDEX sy-tabix.
  ELSE.
    CLEAR gs_vendor.
    gs_vendor-lifnr    = gs_display-lifnr.
    gs_vendor-name1    = gs_display-name1.
    gs_vendor-menge    = gs_display-menge.
    gs_vendor-open_po  = gs_display-open_po_qty.
    gs_vendor-gr_menge = gs_display-gr_menge.
    gs_vendor-gr_dmbtr = gs_display-gr_dmbtr.
    gs_vendor-iv_dmbtr = gs_display-iv_dmbtr.
    APPEND gs_vendor TO gt_vendor.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SETTING_MATERIAL_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM setting_material_data .
  "  Material 집계
  READ TABLE gt_material INTO gs_material
    WITH KEY matnr = gs_display-matnr.

  IF sy-subrc = 0.
    gs_material-menge    = gs_material-menge    + gs_display-menge.
    gs_material-open_po  = gs_material-open_po  + gs_display-open_po_qty.
    gs_material-gr_menge = gs_material-gr_menge + gs_display-gr_menge.
    gs_material-gr_dmbtr = gs_material-gr_dmbtr + gs_display-gr_dmbtr.
    gs_material-iv_dmbtr = gs_material-iv_dmbtr + gs_display-iv_dmbtr.
    MODIFY gt_material FROM gs_material INDEX sy-tabix.
  ELSE.
    CLEAR gs_material.
    gs_material-matnr    = gs_display-matnr.
    gs_material-maktx    = gs_display-maktx.
    gs_material-menge    = gs_display-menge.
    gs_material-open_po  = gs_display-open_po_qty.
    gs_material-gr_menge = gs_display-gr_menge.
    gs_material-gr_dmbtr = gs_display-gr_dmbtr.
    gs_material-iv_dmbtr = gs_display-iv_dmbtr.
    APPEND gs_material TO gt_material.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  LOOPING_GT_EKBE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM looping_gt_ekbe .

  LOOP AT gt_ekbe INTO gs_ekbe  
        WHERE ebeln = gs_display-ebeln
          AND ebelp = gs_display-ebelp.

    IF gs_ekbe-vgabe = '1'.

      gr_d_cnt = gr_d_cnt + 1.
      gs_display-gr_gjahr = gs_ekbe-gjahr.
      gs_display-gr_bwart = gs_ekbe-bwart.
      gs_display-gr_belnr = gs_ekbe-belnr.

      IF gs_ekbe-shkzg = 'H'.
        gs_display-gr_menge = gs_display-gr_menge - gs_ekbe-menge.
        gs_display-gr_dmbtr = gs_display-gr_dmbtr - gs_ekbe-dmbtr.
      ELSE.
        gs_display-gr_menge = gs_display-gr_menge + gs_ekbe-menge.
        gs_display-gr_dmbtr = gs_display-gr_dmbtr + gs_ekbe-dmbtr.
      ENDIF.

    ELSEIF gs_ekbe-vgabe = '2'.   " IV
      gs_display-iv_dmbtr = gs_display-iv_dmbtr + gs_ekbe-dmbtr.
      gs_display-iv_belnr = gs_ekbe-belnr.
      gs_display-iv_gjahr = gs_ekbe-gjahr.
    ENDIF.

  ENDLOOP.
ENDFORM.
