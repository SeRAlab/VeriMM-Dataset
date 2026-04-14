module top_module(ctrl,
    D0,
    D1,
    S);input ctrl;
  input [7:0] D0;
  input [7:0] D1;
  output [7:0] S;

  wire [7:0] S;
  wire [7:0] not_ctrl;
  wire [7:0] and1;
  wire [7:0] and2;

  assign not_ctrl = ~ctrl;
  assign and1 = D0 & not_ctrl;
  assign and2 = D1 & ctrl;
  assign S = and1 | and2;
endmodule