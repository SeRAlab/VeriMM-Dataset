module t_flip_flop (
  input clk,
  input reset,
  input enable,
  output reg Q
);

  always @(posedge clk) begin
    if (reset)
      Q <= 0;
    else if (enable)
      Q <= ~Q;
  end

endmodule