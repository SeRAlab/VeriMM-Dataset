module top_module(
  input clk,
  input rst,
  input [31:0] in,
  output reg [31:0] out
);always @(posedge clk) begin
  if (rst) begin
    out <= in * 2;
  end else begin
    out <= in / 2;
  end
end

endmodule