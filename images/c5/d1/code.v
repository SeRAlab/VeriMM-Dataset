module t_flip_flop(input t, input clk, output reg q);

  reg d;
  always @(posedge clk) begin
    d <= q ^ t;
  end

  assign q = d;

endmodule