module top_module(Y , a);input [2:0] Y; 
 output [7:0] a; 
 wire [7:0] a;

 
 assign a[0] = ~Y[2] & ~Y[1] & ~Y[0];
 assign a[1] = ~Y[2] & ~Y[1] & Y[0];
 assign a[2] = ~Y[2] & Y[1] & ~Y[0];
 assign a[3] = ~Y[2] & Y[1] & Y[0];
 assign a[4] = Y[2] & ~Y[1] & ~Y[0];
 assign a[5] = Y[2] & ~Y[1] & Y[0];
 assign a[6] = Y[2] & Y[1] & ~Y[0];
 assign a[7] = Y[2] & Y[1] & Y[0];

endmodule