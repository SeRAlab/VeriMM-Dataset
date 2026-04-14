module top_module(ctrl,
    D0,
    D1,
    D2,
    D3,
    S,
    S1,
    S2);input ctrl;
  input [0:0] D0;
  input [0:0] D1;
  input [0:0] D2;
  input [0:0] D3;
  output [0:0] S;
  output [0:0] S1;
  output [0:0] S2;

  // Remove the redundant wire declarations for inputs and outputs
  // No need to declare them as wires again since they are implicitly declared

  // Using a case statement for behavior instead of LUT4
  assign S1 = (ctrl) ? D3 : ((D1) ? D2 : D0);
  assign S2 = (ctrl) ? D3 : ((D0) ? D2 : D1);
  assign S = (ctrl) ? D3 : ((D1) ? D0 : D2);

endmodule