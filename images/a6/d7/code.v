module top_module(b,g);parameter SZ = 5; 
  output [SZ-1:0] b; 
  input [SZ-1:0] g; 
  reg [SZ-1:0] b; 
  integer i; 
  always @(g) 
  for (i=0; i<SZ; i=i+1) 
  b[i] = ^(g >> i); 
 endmodule