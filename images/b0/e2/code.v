module top_module(
  input signed [n-1:0] num,
  output [n-1:0] abs_num
);parameter n = 8; // number of bits in the input number

assign abs_num = (num[n-1] == 1) ? (~num + 1) : num;

endmodule