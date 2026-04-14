module top_module(
  input signed [15:0] in1,
  input signed [15:0] in2,
  input signed [15:0] T,
  output signed [15:0] out1,
  output signed [15:0] out2
);wire signed [15:0] abs_in1 = (in1 < 0) ? -in1 : in1;
  wire signed [15:0] abs_in2 = (in2 < 0) ? -in2 : in2;

  assign out1 = (abs_in1 <= T) ? in1 : (in1 < 0 ? -T : T);
  assign out2 = (abs_in2 <= T) ? in2 : (in2 < 0 ? -T : T);

endmodule