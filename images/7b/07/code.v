module top_module(sum, g, p, a, b, cin);output sum; 
  output g; 
  output p; 
  input a; 
  input b; 
  input cin; 
  assign sum = a ^ b ^ cin; 
  assign g = a & b; 
  assign p = a | b; 
 endmodule