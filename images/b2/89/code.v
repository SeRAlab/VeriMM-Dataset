module top_module(
  input [17:0] input_port,
  output [9:0] output_port
);assign output_port = input_port[12:3];

endmodule