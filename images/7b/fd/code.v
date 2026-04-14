module top_module(
  input [3:0] input_a,
  input [3:0] input_b,
  input input_c,
  input input_d,
  input input_e,
  input clk,
  output [3:0] output_a,
  output [3:0] output_b,
  output output_c,
  output output_d,
  output output_e
);wire add_sub = input_c ^ input_d;
  wire and_or = input_c & input_d;
  wire greater_than = (input_a >= input_b);
  wire less_than = (input_a < input_b);

  assign output_a = add_sub ? (greater_than ? input_a - input_b : input_a + input_b) : (and_or ? input_a & input_b : input_a | input_b);
  assign output_b = input_b;
  assign output_c = input_e ? ~input_c : ~input_d;
  assign output_d = greater_than;
  assign output_e = less_than;

endmodule