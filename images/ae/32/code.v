module top_module(sel, d0, d1, d2, d3, q);input [1:0] sel; 
  input [3:0] d0, d1, d2, d3; 
  output [3:0] q; 
  assign q = sel == 2'b00 ? d0 : 
  2'b01 ? d1 : 
  2'b10 ? d2 : d3; 
 endmodule