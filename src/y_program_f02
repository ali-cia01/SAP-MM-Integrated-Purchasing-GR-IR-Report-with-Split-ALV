*----------------------------------------------------------------------*
***INCLUDE YFDMM_04_F02.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DATA1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data1.
  IF deletion = ' '.
    ls_loekz-sign   = 'I'.
    ls_loekz-option = 'EQ'.
    ls_loekz-low    = ' '.
    APPEND ls_loekz TO lr_loekz.
  ENDIF.
  SELECT ekpo~loekz ekpo~ebelp ekpo~ebeln ekpo~matnr ekpo~werks ekpo~lgort
         ekpo~menge ekpo~meins ekpo~netpr
         ekko~lifnr ekko~waers
         eban~banfn eban~bnfpo
         makt~maktx
         lfa1~name1
  FROM ekpo JOIN ekko ON ekko~ebeln = ekpo~ebeln
            JOIN makt ON makt~matnr = ekpo~matnr AND makt~spras = sy-langu
            JOIN lfa1 ON lfa1~lifnr = ekko~lifnr
            LEFT JOIN eban ON eban~banfn = ekpo~banfn AND eban~bnfpo = ekpo~bnfpo
  INTO CORRESPONDING FIELDS OF TABLE gt_display
  WHERE ekko~bukrs IN so_bukrs
    AND ekko~lifnr IN so_lifnr
    AND ekko~ekorg IN so_ekorg
    AND ekko~ekgrp IN so_ekgrp
    AND ekpo~ebeln IN so_ebeln
    AND ekpo~matnr IN so_matnr
    AND ekpo~werks IN so_werks
    AND ekpo~pstyp IN so_pstyp
    AND ekpo~knttp IN so_knttp
    AND ekpo~loekz IN lr_loekz.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_SUB_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_sub_data .
  "ekbe
  SELECT ebeln ebelp belnr gjahr bwart menge dmbtr vgabe shkzg
  FROM ekbe
  INTO CORRESPONDING FIELDS OF TABLE gt_ekbe
  FOR ALL ENTRIES IN gt_display
   WHERE ebeln = gt_display-ebeln
   AND ebelp = gt_display-ebelp
   AND vgabe IN ('1', '2').

  SORT gt_ekbe BY ebeln ebelp vgabe gjahr. 

  LOOP AT gt_display INTO gs_display.

    PERFORM looping_gt_ekbe.

    IF gr_d_cnt > 1.
      gs_display-gr_belnr = icon_display_more.
    ENDIF.

    IF gs_display-gr_menge = gs_display-menge AND
       gs_display-iv_dmbtr = gs_display-gr_dmbtr.
      gs_display-status = icon_green_light.
    ELSEIF gs_display-gr_menge = gs_display-menge OR
           gs_display-iv_dmbtr = gs_display-gr_dmbtr.
      gs_display-status = icon_yellow_light.
    ELSE.
      gs_display-status = icon_red_light.
    ENDIF.
    gs_display-open_po_qty =  gs_display-menge -  gs_display-gr_menge.
    gs_display-gr_proc_qty =  gs_display-open_po_qty.

    MODIFY gt_display FROM gs_display .

    CLEAR: gs_display, gr_d_cnt.

  ENDLOOP.
  SORT gt_display BY ebeln.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  HANDLE_GR_RECEIPT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM handle_gr_receipt .

  PERFORM datacheck_before_bapi_creation.
  CHECK gs_display-open_po_qty > 0.
  PERFORM setting_before_bapi_creation.
  PERFORM bapi_creation.
  PERFORM setting_after_bapi_creation.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  HANDLE_GR_CANCEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM handle_gr_cancel.

  PERFORM check_before_bapi_cancellation.
  CHECK lv_mat_doc IS NOT INITIAL. 
  PERFORM bapi_cancellation.
  PERFORM set_after_bapi_cancellation.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_ALV2_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_alv2_data.
  LOOP AT gt_display INTO gs_display.

    PERFORM setting_vendor_data.
    PERFORM setting_material_data.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SETTING_BEFORE_BAPI_CREATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM setting_before_bapi_creation .
  gv_pstng_date = sy-datum.

  CLEAR ls_fields.
  ls_fields-tabname   = 'BAPI2017_GM_HEAD_01'.
  ls_fields-fieldname = 'PSTNG_DATE'.
  ls_fields-fieldtext = '전기일'.
  ls_fields-value     = gv_pstng_date.
  APPEND ls_fields TO lt_fields.

  CALL FUNCTION 'POPUP_GET_VALUES'
    EXPORTING
      popup_title     = '전기일 입력'
    IMPORTING
      returncode      = lv_answer
    TABLES
      fields          = lt_fields
    EXCEPTIONS
      error_in_fields = 1
      OTHERS          = 2.

  IF lv_answer = 'A'.   " ← A는 취소 버튼(X버튼)
    RETURN.
  ENDIF.


  READ TABLE lt_fields INTO ls_fields INDEX 1.
  gv_pstng_date = ls_fields-value.

  ls_header-pstng_date = gv_pstng_date.
  ls_header-doc_date   = sy-datum.


  ls_code-gm_code      = '01'.


  IF sy-subrc = 0.
    ls_header-ref_doc_no = gs_display-ebeln. "

    CLEAR ls_item.
    ls_item-material  = gs_display-matnr.   " 자재코드
    ls_item-move_type = '101'.              " 이동유형
    ls_item-po_number = gs_display-ebeln.   " 발주번호
    ls_item-po_item   = gs_display-ebelp.   " 항번
    ls_item-mvt_ind   = 'B'.               " 이동유형지시자
    ls_item-entry_qnt = gs_display-gr_proc_qty.  "gr 진행 중인 수량
    ls_item-entry_uom = gs_display-meins.        " unit
    ls_item-plant     = gs_display-werks.    " plant
    ls_item-stge_loc  = gs_display-lgort.    "  storage location
    APPEND ls_item TO lt_item.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BAPI_CREATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM bapi_creation .
  CLEAR: lt_return, ls_return.
  CLEAR: ls_headret.
  CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
    EXPORTING
      goodsmvt_header  = ls_header
      goodsmvt_code    = ls_code
    IMPORTING
      goodsmvt_headret = ls_headret
    TABLES
      goodsmvt_item    = lt_item
      return           = lt_return.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SETTING_AFTER_BAPI_CREATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM setting_after_bapi_creation .
  READ TABLE lt_return INTO ls_return WITH KEY type = 'E'.

  IF sy-subrc = 0. "e(오류)를 찾았다면
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    MESSAGE ls_return-message TYPE 'E'.
  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'. "저장 완료될 때까지 기다림

    MESSAGE i398(00) WITH '입고처리 완료:' ls_headret-mat_doc '(입고문서)'.

    IF gs_display-gr_belnr IS NOT INITIAL.
      gs_display-gr_belnr = icon_display_more.  " ← 아이콘으로 변경
    ELSE.
      gs_display-gr_belnr = ls_headret-mat_doc. " ← 첫 번째면 문서번호
    ENDIF.

    gs_display-gr_menge    = gs_display-gr_menge + gs_display-gr_proc_qty.
    gs_display-open_po_qty = gs_display-menge - gs_display-gr_menge.
    gs_display-gr_proc_qty = gs_display-open_po_qty.
    gs_display-gr_gjahr = ls_headret-doc_year.

    IF gs_display-gr_menge = gs_display-menge AND
       gs_display-iv_dmbtr = gs_display-gr_dmbtr.
      gs_display-status = icon_green_light.
    ELSEIF gs_display-gr_menge = gs_display-menge OR
           gs_display-iv_dmbtr = gs_display-gr_dmbtr.
      gs_display-status = icon_yellow_light.
    ELSE.
      gs_display-status = icon_red_light.
    ENDIF.

    MODIFY gt_display FROM gs_display INDEX ls_row_no-row_id.

    CALL METHOD go_grid1->refresh_table_display( ). 

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DATACHECK_BEFORE_BAPI_CREATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM datacheck_before_bapi_creation .
  CLEAR: lt_row_no, ls_row_no.
  CALL METHOD go_grid1->check_changed_data( ).


  CALL METHOD go_grid1->get_selected_rows
    IMPORTING
      et_row_no = lt_row_no.

  IF lt_row_no IS INITIAL.
    MESSAGE '입고처리할 항목을 선택하세요.' TYPE 'I'.
    RETURN.
  ENDIF.

  IF lines( lt_row_no ) > 1.
    MESSAGE '입고처리는 1건만 선택 가능합니다.' TYPE 'I'.
    RETURN.
  ENDIF.

  READ TABLE lt_row_no INTO ls_row_no INDEX 1.
  READ TABLE gt_display INTO gs_display INDEX ls_row_no-row_id.

  IF gs_display-open_po_qty <= 0.
    MESSAGE '입고처리할 수량이 없습니다.' TYPE 'I'.
    RETURN.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CHECK_BEFORE_BAPI_CANCELLATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM check_before_bapi_cancellation .
  CLEAR: lt_row_no, ls_row_no.

  CALL METHOD go_grid1->get_selected_rows
    IMPORTING
      et_row_no = lt_row_no.

  IF lt_row_no IS INITIAL.
    MESSAGE '입고취소할 항목을 선택하세요.' TYPE 'I'.
    RETURN.
  ENDIF.
  IF lines( lt_row_no ) > 1.
    MESSAGE '입고취소는 1건만 선택 가능합니다.' TYPE 'I'.
    RETURN.
  ENDIF.

  READ TABLE lt_row_no INTO ls_row_no INDEX 1.
  READ TABLE gt_display INTO gs_display INDEX ls_row_no-row_id.


  IF gs_display-gr_belnr IS INITIAL.
    MESSAGE '입고된 문서가 없습니다.' TYPE 'I'.
    RETURN.
  ENDIF.

  IF gs_display-gr_belnr = icon_display_more.
    MESSAGE '해당 PO는 다건의 입고문서가 존재합니다.' TYPE 'I'.
    RETURN.
  ENDIF.

  lv_mat_doc  = gs_display-gr_belnr.
  lv_mat_year = gs_display-gr_gjahr.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BAPI_CANCELLATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM bapi_cancellation .

  CLEAR: lt_return, ls_return.
  CLEAR: ls_headret.
  CALL FUNCTION 'BAPI_GOODSMVT_CANCEL'
    EXPORTING
      materialdocument = lv_mat_doc
      matdocumentyear  = lv_mat_year
    IMPORTING
      goodsmvt_headret = ls_headret
    TABLES
      return           = lt_return.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_AFTER_BAPI_CANCELLATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_after_bapi_cancellation .
  READ TABLE lt_return INTO ls_return WITH KEY type = 'E'.
  IF sy-subrc = 0.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    MESSAGE ls_return-message TYPE 'E'.
  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.
    MESSAGE i398(00) WITH '입고취소 완료:' ls_headret-mat_doc '(취소문서)'.


    gs_display-gr_menge    = 0.
    gs_display-gr_dmbtr    = 0.
    gs_display-gr_bwart    = ''.
    gs_display-open_po_qty = gs_display-menge.
    gs_display-gr_proc_qty = gs_display-menge.
    CLEAR: gs_display-gr_belnr, gs_display-gr_gjahr.

    IF gs_display-gr_menge = gs_display-menge AND
       gs_display-iv_dmbtr = gs_display-gr_dmbtr.
      gs_display-status = icon_green_light.
    ELSEIF gs_display-gr_menge = gs_display-menge OR
           gs_display-iv_dmbtr = gs_display-gr_dmbtr.
      gs_display-status = icon_yellow_light.
    ELSE.
      gs_display-status = icon_red_light.
    ENDIF.

    MODIFY gt_display FROM gs_display INDEX ls_row_no-row_id.
  ENDIF.

  go_grid1->refresh_table_display( ).
ENDFORM.
