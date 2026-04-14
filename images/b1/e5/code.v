module top_module(input [7:0] din_a, input [7:0] din_b, output [7:0] dout_a);assign dout_a = test(din_a,din_b); 
  function [7:0] test; 
  input [7:0] a; 
  input [7:0] b; 
  begin : TEST 
  integer i; 
  for (i = 0; i <= 7; i = i + 1) 
  test[i] = a[i] & b[i]; 
  end 
  endfunction 
 endmodule