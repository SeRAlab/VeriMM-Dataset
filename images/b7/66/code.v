module top_module(ctrl,
    D0,
    D1,
    S);input ctrl;
  input [0:0] D0;
  input [0:0] D1;
  output [0:0] S;

  // Use a conditional assign statement instead of LUT3
  assign S = (ctrl) ? D1 : D0;

endmodule