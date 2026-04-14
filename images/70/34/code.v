module t_ff_sync_reset(
  input clk,
  input reset,
  input t,
  output reg q
);

  always @(posedge clk) begin
    if (reset)
      q <= 1'b0;
    else if (t)
      q <= ~q;
  end

endmodule