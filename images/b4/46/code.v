module top_module(
  input CLK, EN, TE,
  output reg ENCLK  // Changed to reg type
);wire gated_clk;

  // Gating logic
  assign gated_clk = (TE) ? CLK : (EN) ? CLK : 1'b0;

  // D flip-flop with enable
  always @(posedge CLK) begin
    if (EN) begin
      ENCLK <= gated_clk;
    end
  end

endmodule