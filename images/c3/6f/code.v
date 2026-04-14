module gated_d_ff_en (CLK, EN, TE, ENCLK);
  input CLK, EN, TE;
  output ENCLK;

  reg ENCLK_reg;

  always @(posedge CLK) begin
    if (EN) begin
      ENCLK_reg <= TE;
    end
  end

  assign ENCLK = EN ? ENCLK_reg : 1'b0;

endmodule