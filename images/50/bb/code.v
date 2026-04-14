module top_module(din, bcd, resttemp);input [15:0] din; 
 output [3:0] bcd; 
 output [15:0] resttemp; 
 wire [19:0] buffer; 
 assign buffer = {3'd0,din,1'd0} + {1'd0,din,3'd0}; 
 assign bcd = buffer[19:16]; 
 assign resttemp = buffer[15:0]; 
 endmodule