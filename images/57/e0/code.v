module top_module(
  input [3:0] a,
  output [2:0] k);assign k[0] = a[0] | (~a[0] & ~a[1] & a[2]);
  assign k[1] = (a[1] & ~a[0]) | (~a[0] & ~a[1] & a[2]);
  assign k[2] = ~a[0] & ~a[1] & ~a[2] & a[3];
  
  
endmodule