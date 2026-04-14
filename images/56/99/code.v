module top_module(a, b, c, y);input a; 
  input signed [1:0] b; 
  input signed [2:0] c; 
  output y; 
  assign y = ^(a ? b : c); 
 endmodule