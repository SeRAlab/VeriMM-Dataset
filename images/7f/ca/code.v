module top_module(
  input [3:0] A,
  input [3:0] B,
  input CIN,
  output [3:0] SUM,
  output COUT,
  input VDD,
  input VSS
);wire [3:0] sum;
  wire cout;

  assign sum = A + B + CIN;
  assign COUT = (sum > 4'b1111);

  // Using a simple multiplexer logic instead of missing module
  assign SUM = COUT ? 4'b0000 : sum;

endmodule