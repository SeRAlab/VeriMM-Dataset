module top_module(
  input [n-1:0] clk,
  input sel,
  output reg clk_out // Changed to reg type
);parameter n = 4; // number of input clock signals

always @* begin // Using combinational block
  clk_out = sel ? clk[1] : clk[0]; // Mux logic
end

endmodule