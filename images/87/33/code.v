module top_module(
  input clk,
  input reset,
  input ena,
  output reg [3:0] q
);always @(posedge clk) begin
  if (reset) begin
    q <= 4'b0000;
  end else if (ena) begin
    q <= q + 1;
    if (q == 4'b1111) begin
      q <= 4'b0000;
    end
  end
end

endmodule