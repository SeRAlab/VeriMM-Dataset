module top_module(y,a,b);output y; 
  input a; 
  input b; 
  assign #1 y = a | b; 
 endmodule