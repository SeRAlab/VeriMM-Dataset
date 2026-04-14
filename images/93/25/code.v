module top_module(
  carry,
  sum,
  in3,
  in2,
  in1
  );input in1, in2, in3;
  output sum, carry;

  assign sum=in1^in2^in3;
  assign carry=(in1&in2) | (in2&in3) | (in1&in3);

endmodule