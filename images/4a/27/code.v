module top_module(
  input CLK, 
  input EN, 
  input TE, 
  output ENCLK
);reg D;
  reg CLK_EN;
  reg ENCLK_reg; // Internal register to hold the output

  always @(posedge CLK) begin
    if (EN && TE) begin
      D <= 1'b1;
      CLK_EN <= 1'b1;
    end else begin
      D <= 1'b0;
      CLK_EN <= 1'b0;
    end
  end

  // Simple D flip-flop for demonstration
  always @(posedge CLK) begin
    if (CLK_EN) begin
      ENCLK_reg <= D; // Latch D when CLK_EN is high
    end
  end

  assign ENCLK = ENCLK_reg; // Assign the internal register to the output

endmodule