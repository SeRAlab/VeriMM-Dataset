module top_module(
  input   clk_in,
  input   test_mode,
  input   clock_en,
  input   FPGA_SOURCE,
  output  clk_out
);wire clk_enb;

`ifdef FPGA_SOURCE
assign clk_enb = 1'b1;
`else
assign clk_enb = (clk_in & (clock_en | test_mode));
`endif

assign clk_out = clk_in & clk_enb;

endmodule