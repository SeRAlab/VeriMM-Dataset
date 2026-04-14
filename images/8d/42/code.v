module top_module(a, c);input a; 
  output c; 
  wire c1 = ~a; 
  assign c = c1; 
 endmodule