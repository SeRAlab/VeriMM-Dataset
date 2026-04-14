module top_module( CLK, EN, TE, ENCLK );input CLK, EN, TE;
  output ENCLK;

  reg ENCLK_reg;
  wire D;

  // D flip-flop
  always @(posedge CLK) begin
    if (EN) begin
      ENCLK_reg <= D;
    end
  end

  // Transmit enable logic
  assign D = (TE) ? CLK : 1'b0;

  // Clock gate logic
  always @(posedge CLK) begin
    if (!EN) begin
      ENCLK_reg <= 1'b0;
    end
  end

  assign ENCLK = ENCLK_reg;

endmodule