module top_module(
  input [11:0] r,
  input [11:0] g,
  input [11:0] b,
  output [11:0] gray
  );wire [13:0] sum0;
  wire [13:0] sum1;
  wire [13:0]gray_wire;
  
  assign sum0 = r+b;
  assign sum1 = sum0+g;
  assign gray_wire = sum1 / 14'd3;
  
  
  
  
  assign gray = (gray_wire[13:12] == 2'd0) ? { gray_wire[11:3],3'd0 } : 12'hff8;
  endmodule