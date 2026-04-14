module top_module(z,a, b, cin, add32);input [31:0] a; 
  input [31:0] b; 
  input cin; 
  input add32; 
  output [31:0] z; 
  wire cout15; 
  wire cin16; 
  assign cin16 = (add32)? cout15: cin; 
  assign {cout15, z[15:0]} = a[15:0]+b[15:0]+{15'b0,cin}; 
  assign z[31:16] = a[31:16]+b[31:16]+{15'b0,cin16}; 
 endmodule