module top_module(
  input [n-1:0] clk,
  input sel,
  output sys_clk
);parameter n = 4; // number of input clocks

reg [n-1:0] clk_buf; // clock buffers

always @ (clk or sel) begin
  case (sel)
    0: clk_buf = clk[0];
    1: clk_buf = clk[1];
    2: clk_buf = clk[2];
    3: clk_buf = clk[3];
    default: clk_buf = clk[0];
  endcase
end

assign sys_clk = clk_buf;

endmodule