module top_module(y,a,b,c,d);output y; 
  input a; 
  input b; 
  input c; 
  input d; 
  assign #1 y = a | b | c | d; 
 endmodule