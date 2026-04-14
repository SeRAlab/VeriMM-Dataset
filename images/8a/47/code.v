module top_module(ctrl,
    D0,
    D1,
    S);input ctrl;
  input [7:0]D0;
  input [7:0]D1;
  output [7:0]S;

  // Implementing a 2-to-1 multiplexer for each bit
  assign S = (ctrl) ? D1 : D0;

endmodule