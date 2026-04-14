module top_module(
  input clk,
  output [n-1:0] clk_out
);parameter n = 4; // number of output clock signals to be distributed.

reg clk_buffered;
assign clk_out = {n{clk_buffered}};

always @(posedge clk) begin
  clk_buffered <= clk;
end

endmodule