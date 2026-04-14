module top_module(
  input clk,
  input reset,
  input up_down,
  output reg [3:0] q
);always @(posedge clk) begin
    if (reset) begin
      q <= 4'b0;
    end else begin
      if (up_down) begin
        q <= q - 1;
      end else begin
        q <= q + 1;
      end
    end
  end

endmodule