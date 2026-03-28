*&---------------------------------------------------------------------*
*&  Include           YFDMM_04_CLS
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           MZFDMM_EX2_04_CLS
*&---------------------------------------------------------------------*
CLASS lcl_handler DEFINITION.
  PUBLIC SECTION.
    METHODS: on_double_click
                  FOR EVENT double_click OF cl_gui_alv_grid
      IMPORTING e_row e_column es_row_no.
    METHODS: on_hotspot_click
                  FOR EVENT hotspot_click OF cl_gui_alv_grid
      IMPORTING e_row_id e_column_id es_row_no.
    CLASS-METHODS: on_toolbar
                  FOR EVENT toolbar OF cl_gui_alv_grid
      IMPORTING e_object e_interactive.
    CLASS-METHODS: on_user_command
                  FOR EVENT user_command OF cl_gui_alv_grid
      IMPORTING e_ucomm.
ENDCLASS.
CLASS lcl_handler IMPLEMENTATION.
  METHOD on_double_click.

    READ TABLE gt_display INTO gs_display INDEX es_row_no-row_id.
    IF sy-subrc = 0.
      CASE e_column-fieldname.
        WHEN 'BANFN'.                                    " PR 조회
          SET PARAMETER ID 'BAN' FIELD gs_display-banfn.
          CALL TRANSACTION 'ME53N' AND SKIP FIRST SCREEN.
        WHEN 'LIFNR'.                                    " Vendor 조회
          SET PARAMETER ID 'LIF' FIELD gs_display-lifnr.
          CALL TRANSACTION 'XK03' AND SKIP FIRST SCREEN.
        WHEN 'GR_BELNR'.
          CALL SCREEN 300 STARTING AT 10 5
                          ENDING   AT 100 25.
      ENDCASE.
    ENDIF.

  ENDMETHOD.
  METHOD on_hotspot_click.
    READ TABLE gt_display INTO gs_display INDEX e_row_id-index.
    IF sy-subrc = 0.
      CASE e_column_id-fieldname.
        WHEN 'EBELN'.                                    " PO 조회
          SET PARAMETER ID 'BES' FIELD gs_display-ebeln.
          SET PARAMETER ID 'BSP' FIELD gs_display-ebelp.
          CALL TRANSACTION 'ME23N' AND SKIP FIRST SCREEN.
        WHEN 'MATNR'.                                    " Material 조회
          SET PARAMETER ID 'MAT' FIELD gs_display-matnr.
          SET PARAMETER ID 'MXX' FIELD 'X'.   "  Purchasing 뷰로 자동선택함
          SET PARAMETER ID 'WRK' FIELD gs_display-werks. "Plant번호도 바로 읽어서 보냄
          CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.

      ENDCASE.
    ENDIF.
  ENDMETHOD.
  METHOD on_toolbar.
    DATA: ls_toolbar TYPE stb_button.

    " 구분선 추가
    CLEAR ls_toolbar.
    ls_toolbar-butn_type = 3. " Separator
    APPEND ls_toolbar TO e_object->mt_toolbar.

    " Doc Flow 버튼 추가
    CLEAR ls_toolbar.
    ls_toolbar-function  = 'ZDOCFLOW'.        " Function Code
    ls_toolbar-icon      = icon_display.       " 아이콘
    ls_toolbar-quickinfo = 'Document Flow'.    " 툴팁
    ls_toolbar-text      = 'Doc Flow'.         " 버튼 텍스트
    ls_toolbar-disabled  = ' '.
    APPEND ls_toolbar TO e_object->mt_toolbar.

  ENDMETHOD.
  METHOD on_user_command.
    CASE e_ucomm.
      WHEN 'ZDOCFLOW'.
        PERFORM handle_doc_flow.
    ENDCASE.
  ENDMETHOD.

ENDCLASS.
DATA: go_handler TYPE REF TO lcl_handler.
