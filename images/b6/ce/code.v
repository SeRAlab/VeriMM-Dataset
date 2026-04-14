module top_module(
    input wire in0,
    input wire in1,
    input wire in2,
    input wire in3,
    output wire out
);wire w1, w2, w3, w4, w5, w6, w7;

  assign w1 = in0 ^ in1;
  assign w2 = in2 ^ in3;
  assign w3 = w1 ^ w2;
  assign w4 = w3 ^ in0;
  assign w5 = w3 ^ in2;
  assign w6 = w4 ^ in1;
  assign w7 = w6 ^ in3;
  
  assign out = w7;

endmodule