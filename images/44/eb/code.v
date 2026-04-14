module top_module(Din,
    Dout);input [17:0]Din;
  output [9:0]Dout;

  wire [17:0]Din;

  assign Dout[9:0] = Din[12:3];
endmodule