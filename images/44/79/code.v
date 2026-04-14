module top_module(
  input clk,
  input rst,
  output reg [31:0] q
);always @(posedge clk, posedge rst) begin
    if (rst) begin
      q <= 0;
    end else begin
      q <= q + 1;
    end
  end

endmodule