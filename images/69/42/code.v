module top_module(
  input clk,
  input [0:0] probe0,
  input [7:0] probe1,
  input [0:0] probe2,
  input [7:0] probe3,
  output [0:0] out_probe0,
  output [7:0] out_probe1,
  output [0:0] out_probe2,
  output [7:0] out_probe3
);assign out_probe0 = probe0;
  assign out_probe1 = ~probe1;
  assign out_probe2 = probe2;
  assign out_probe3 = probe3 & 8'h55;

endmodule