module top_module(
  input clk,
  output reg [3:0] gray_code
);always @(posedge clk) begin
    gray_code <= gray_code ^ (gray_code >> 1);
  end

endmodule