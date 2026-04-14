module top_module(
  input clk_in,
  input enable,
  output clk_out
  );// Use a generic clock buffer instead of BUFGCTRL as it may be not defined in your environment
  assign clk_out = (enable) ? clk_in : 1'b0; // Assuming you want to output clk_in when enabled, else 0

endmodule