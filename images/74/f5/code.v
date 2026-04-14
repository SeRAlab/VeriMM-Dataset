module top_module(Din,
    Dout);input [17:0]Din;
  output [1:0]Dout;

  wire [17:0]Din;

  assign Dout[1:0] = Din[1:0];
endmodule