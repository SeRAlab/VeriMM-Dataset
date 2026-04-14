module top_module(
  input wire [7:0] in0,
  input wire [7:0] in1,
  input wire [7:0] in2,
  input wire [7:0] in3,
  input wire sel,
  output wire [7:0] out
);assign out = sel ? (sel ? in3 : in2) : (sel ? in1 : in0);

endmodule