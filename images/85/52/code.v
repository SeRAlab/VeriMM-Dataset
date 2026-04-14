module top_module(control,dp);input [1:0] control; 
  output dp; 
  assign dp = (control == 2'b11) ? 1'b1 : 
  (control == 2'b10) ? 1'b1 : 
  (control == 2'b01) ? 1'b1 : 
  1'b1; 
 endmodule