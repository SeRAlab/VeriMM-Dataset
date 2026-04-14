module top_module(a1_0,op,be);input [1:0] a1_0; 
  input [1:0] op; 
  output [3:0] be; 
  assign be=(op==2'b00)?4'b1111: 
  (op==2'b01)?(a1_0[1]?4'b1100:4'b0011): 
 (op==2'b10)?((a1_0==2'b00)?4'b0001:(a1_0==2'b01)?4'b0010:(a1_0==2'b10)?4'b0100:4'b1000): 
  4'b0000; 
 endmodule