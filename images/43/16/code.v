module top_module(
  input [3:0] input_a,
  input [3:0] input_b,
  input [1:0] input_c,
  input input_d,
  output [4:0] output_x,
  output [2:0] output_y
);assign output_x = {input_a, input_b, input_c, input_d};
  assign output_y = (input_c + input_d) % 8;

endmodule