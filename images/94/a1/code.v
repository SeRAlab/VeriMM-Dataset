module top_module(i,sel,x,y);input [15:0] i;
  input sel;
  output [15:0] x, y;

  assign x = (sel == 1'b0) ? i : 16'b0;
  assign y = (sel == 1'b0) ? 16'b0 : i;

endmodule