module t_ff (
  input clk,
  input reset,
  input t,
  output reg q
);

always @(posedge clk, negedge reset) begin
  if (!reset) begin
    q <= 1'b0;
  end else begin
    if (t) begin
      q <= ~q;
    end
  end
end

endmodule
