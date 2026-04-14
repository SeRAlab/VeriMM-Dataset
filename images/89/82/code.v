module top_module(
  input clk,
  input reset,
  input en,
  input byte_lo,
  input byte_hi,
  input [15:0] d,
  output reg [15:0] q
);always @(posedge clk) begin
    if (reset) begin
      q <= 16'b0;
    end else if (en) begin
      if (byte_lo) begin
        q[7:0] <= d[7:0];
      end
      if (byte_hi) begin
        q[15:8] <= d[15:8];
      end
    end
  end

endmodule