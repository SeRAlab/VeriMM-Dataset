module top_module(a, b, y);input [2:0] a;
  input signed [1:0] b;
  output y;
  
  wire [2:0] a_neg;
  assign a_neg = ~a;
  
  wire [2:0] a_shifted;
  assign a_shifted = a >> 1;
  
  assign y = (a_shifted == b) ? 1'b1 : 1'b0;
endmodule