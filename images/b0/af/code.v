module top_module(
  input a,
  input b,
  input c,
  output y
);wire ab_xor;
  wire abc_xor;
  
  assign ab_xor = a ^ b;
  assign abc_xor = ab_xor ^ c;
  assign y = abc_xor;
  
endmodule