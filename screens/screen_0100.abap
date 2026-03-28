PROCESS BEFORE OUTPUT.
  MODULE status_0200.
  MODULE clear_okcode.
  MODULE create_and_transfer.

PROCESS AFTER INPUT.
  MODULE exit_command_0200 AT EXIT-COMMAND.
  MODULE user_command_0200.
