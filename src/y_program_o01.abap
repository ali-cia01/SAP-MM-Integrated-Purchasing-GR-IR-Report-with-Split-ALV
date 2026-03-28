*&---------------------------------------------------------------------*
*&  Include           YFDMM_04_O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
  SET PF-STATUS 'STATUS_0200'.
  IF deletion = 'X'.
    SET TITLEBAR 'TITLE_0200_DEL'.
  ELSE.
    SET TITLEBAR 'TITLE_0200'.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CLEAR_OKCODE  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE clear_okcode OUTPUT.
  CLEAR ok_code.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CREATE_AND_TRANSFER  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE create_and_transfer OUTPUT.

  IF go_container1 IS INITIAL.

    CREATE OBJECT go_container1
      EXPORTING
        container_name = 'AREA1'
      EXCEPTIONS
        OTHERS         = 1.
    IF sy-subrc <> 0.
      MESSAGE a010(bc405_408).
    ENDIF.

    CREATE OBJECT go_grid1
      EXPORTING
        i_parent = go_container1
      EXCEPTIONS
        OTHERS   = 1.
    IF sy-subrc <> 0.
      MESSAGE a010(bc405_408).
    ENDIF.

    CREATE OBJECT go_handler.

    SET HANDLER go_handler->on_double_click  FOR go_grid1.
    SET HANDLER go_handler->on_hotspot_click FOR go_grid1.
    SET HANDLER go_handler->on_toolbar       FOR go_grid1.
    SET HANDLER go_handler->on_user_command  FOR go_grid1.

    PERFORM set_fcat.

    go_grid1->set_table_for_first_display(
    EXPORTING
       is_layout       = gs_layout
    CHANGING
     it_outtab = gt_display
     it_fieldcatalog = gt_fcat
      it_sort         = gt_sort
    EXCEPTIONS
    OTHERS = 1
    ).
    CLEAR gs_layout.
    IF sy-subrc <>  0.
      MESSAGE a010(bc405_408).
    ENDIF.

    CREATE OBJECT go_container2
      EXPORTING
        container_name = 'AREA2'
      EXCEPTIONS
        OTHERS         = 1.
    IF sy-subrc <> 0.
      MESSAGE a010(bc405_408).
    ENDIF.

    CREATE OBJECT go_splitter
      EXPORTING
        parent  = go_container2
        rows    = 2
        columns = 1.

    go_cell_top    = go_splitter->get_container( row = 1 column = 1 ).
    go_cell_bottom = go_splitter->get_container( row = 2 column = 1 ).

    CREATE OBJECT go_grid2
      EXPORTING
        i_parent = go_cell_top
      EXCEPTIONS
        OTHERS   = 1.
    IF sy-subrc <> 0.
      MESSAGE a010(bc405_408).
    ENDIF.

    PERFORM set_fcat_alv2.

    go_grid2->set_table_for_first_display(

     EXPORTING
       is_layout  = gs_layout
    CHANGING
     it_outtab = gt_vendor
     it_fieldcatalog = gt_fcat_vendor
      it_sort         = gt_sort2
    EXCEPTIONS
    OTHERS = 1
    ).
    CLEAR gs_layout.
    IF sy-subrc <> 0.
      MESSAGE a010(bc405_408).
    ENDIF.

    CREATE OBJECT go_grid3
      EXPORTING
        i_parent = go_cell_bottom
      EXCEPTIONS
        OTHERS   = 1.
    IF sy-subrc <> 0.
      MESSAGE a010(bc405_408).
    ENDIF.

    PERFORM set_fcat_alv3.

    go_grid3->set_table_for_first_display(

       EXPORTING
       is_layout       = gs_layout
    CHANGING
     it_outtab       = gt_material
    it_fieldcatalog = gt_fcat_material
     it_sort         = gt_sort3
    EXCEPTIONS
    OTHERS = 1
    ).
    CLEAR gs_layout.
    IF sy-subrc <> 0.
      MESSAGE a010(bc405_408).
    ENDIF.


  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0300  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0300 OUTPUT.
  SET PF-STATUS 'STATUS_0300'.
  SET TITLEBAR 'TITLE_0300'.

  CASE  tab_ctl-activetab.
    WHEN 'T1'.
      IF gs_display-gr_belnr = icon_display_more.
        gv_subs = '0303'.
      ELSE.
        gv_subs = '0301'.
      ENDIF.
    WHEN 'T2'.
      gv_subs = '0302'.
    WHEN OTHERS.
      tab_ctl-activetab = 'T1'.
      IF gs_display-gr_belnr = icon_display_more.
        gv_subs = '0303'.
      ELSE.
        gv_subs = '0301'.
      ENDIF.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CREATE_AND_TRANSFER_GR  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE create_and_transfer_gr OUTPUT.
 IF go_container_gr IS INITIAL.
    CREATE OBJECT go_container_gr
      EXPORTING
        container_name = 'AREA3'
      EXCEPTIONS
        OTHERS         = 1.
    IF sy-subrc <> 0.
      MESSAGE a010(bc405_408).
    ENDIF.

    CREATE OBJECT go_grid_gr
      EXPORTING
        i_parent = go_container_gr
      EXCEPTIONS
        OTHERS   = 1.
    IF sy-subrc <> 0.
      MESSAGE a010(bc405_408).
    ENDIF.

    PERFORM set_fcat_gr.

    go_grid_gr->set_table_for_first_display(
    EXPORTING
     is_layout       = gs_layout
    CHANGING
     it_outtab = gt_gr_doc
     it_fieldcatalog = gt_fcat_gr
    EXCEPTIONS
    OTHERS = 1
    ).

ENDIF.
ENDMODULE.
