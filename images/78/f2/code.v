module top_module(
  input [3:0] data,
  output x,
  output y
);assign x = (data % 2 == 0) ? 1'b1 : 1'b0;
  assign y = (data % 2 == 1) ? 1'b1 : 1'b0;

endmodule