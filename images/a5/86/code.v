module top_module(CLK, EN, TE, ENCLK);input CLK, EN, TE;
  output reg [3:0] ENCLK;
  wire gated_clk;

  // Simplified D flip-flop implementation for gated clock
  reg latch_out;
  always @(posedge CLK) begin
    if (TE) begin
      latch_out <= 1'b0; // Reset the latch
    end else if (EN) begin
      latch_out <= 1'b1; // Enable the latch
    end
  end

  assign gated_clk = latch_out ? CLK : 1'b0; // Gated clock

  always @(posedge gated_clk) begin
    if (EN) begin
      ENCLK <= ENCLK + 1;
    end
  end
endmodule