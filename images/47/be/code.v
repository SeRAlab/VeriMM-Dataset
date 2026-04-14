module top_module(a,b,out);input [1:0] a,b;
  output [3:0] out;
  
  assign out[0] = a[0] & b[0];
  assign out[1] = (a[0] & b[1]) ^ (a[1] & b[0]);
  assign out[2] = (a[1] & b[1]) ^ ((a[0] & b[1]) & (a[1] & b[0]));
  assign out[3] = (a[1] & b[1]) & ((a[0] & b[1]) & (a[1] & b[0]));
endmodule