*&---------------------------------------------------------------------*
*&  Include           YFDMM_04_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_command_0200 INPUT.
  CASE ok_code.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.
  CASE ok_code.
    WHEN 'ZGRECV'.
      PERFORM handle_gr_receipt.
    WHEN 'ZGRCANC'.
      PERFORM handle_gr_cancel.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0300  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0300 INPUT.
  CASE ok_code.
    WHEN 'T1' OR 'T2'.
      tab_ctl-activetab = ok_code.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_COMMAND_0300  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_command_0300 INPUT.
  CASE ok_code.
    WHEN 'EXIT'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  GET_GR_DOC  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_gr_doc OUTPUT.
  SELECT ebeln ebelp belnr gjahr menge dmbtr
    FROM ekbe
    INTO CORRESPONDING FIELDS OF TABLE gt_gr_doc
    WHERE ebeln = gs_display-ebeln
      AND ebelp = gs_display-ebelp
      AND vgabe = '1'.
ENDMODULE.
