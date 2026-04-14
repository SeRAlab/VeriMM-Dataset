module top_module(
  input clk,
  input rst,
  input [7:0] a,
  input [7:0] b,
  output reg [7:0] out,
  output reg valid
);always @(posedge clk) begin
    if (rst) begin
      out <= 8'b0;
      valid <= 1'b0;
    end else begin
      out <= a & b;
      valid <= 1'b1;
    end
  end

endmodule