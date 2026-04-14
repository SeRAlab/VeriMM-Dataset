module top_module(ir, len);input [3:0] ir; 
 output [3:0] len; 
 reg [3:0] len; 
 reg ir32; 
 always @ (ir) 
 begin 
  len = { 
  (ir == 4'b0011), 
  (ir == 4'b0010), 
  (ir == 4'b0001), 
  ((ir | 4'b0101) == 4'b1101) | ((ir | 4'b1100) == 4'b1100) 
  }; 
 end 
 endmodule