module top_module(clk, en, te, enclk);input clk, en, te;
  output reg enclk;

  wire gated_clk;

  // Gated clock using an AND gate
  and gate (gated_clk, clk, en);

  // Transparent latch behavior
  always @(gated_clk or te) begin
    if (te) begin
      enclk <= 1'b1;  // latch is transparent when te is high
    end else begin
      enclk <= 1'b0;  // latch holds value when te is low
    end
  end

endmodule