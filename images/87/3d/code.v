module top_module(
  input clk_in,
  input rst_n,
  output clk_out
);assign clk_out = clk_in;

  // Reset all clocked elements when rst_n is low
  always @(negedge rst_n) begin
    // Reset logic goes here
  end

endmodule