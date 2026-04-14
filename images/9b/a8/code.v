module top_module(
  input clk,
  input rstn,
  input [3:0] n,
  output reg [7:0] n2
);assign n2 = n[0] << 1;
endmodule