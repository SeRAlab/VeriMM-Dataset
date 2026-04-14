module top_module(
  input in1,
  input in2,
  input in3,
  output out
);wire inv_in2;
  assign inv_in2 = ~in2;
  
  assign out = ~(in1 & inv_in2 & in3);

endmodule