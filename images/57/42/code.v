module top_module(ctrl,
    D0,
    D1,
    S);input ctrl;
  input [0:0]D0;
  input [0:0]D1;
  output [0:0]S;

  wire [0:0]S;
  wire ctrl;

  assign S = (ctrl) ? D1 : D0; // Implementing a 2-to-1 multiplexer logic
endmodule