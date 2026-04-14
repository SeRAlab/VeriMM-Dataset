module top_module(
  input wire [15:0] in1,
  input wire [15:0] in2,
  input wire control,
  output wire [15:0] out
);wire [15:0] sum;
  wire [15:0] diff;
  wire cmp;

  // Adder implementation
  assign sum = in1 + in2;

  // Subtractor implementation
  assign diff = in1 - in2;

  // Comparator implementation
  assign cmp = (in1 < in2) ? 1'b1 : 1'b0;

  // Output logic based on control signal
  assign out = control ? diff : sum;

endmodule