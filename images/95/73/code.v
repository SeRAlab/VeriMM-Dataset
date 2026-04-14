module top_module(
  input clk,
  input reset,
  input up_down,
  input enable,
  output reg [8:0] q
);always @(posedge clk or posedge reset) begin
  if (reset) begin
    q <= 0;
  end else if (enable) begin
    if (up_down) begin
      q <= q + 1;
    end else begin
      q <= q - 1;
    end
  end
end

endmodule