module top_module(CLK, EN, TE, ENCLK);input CLK, EN, TE;
  output ENCLK;

  reg ENCLK_reg;

  always @ (posedge CLK) begin
    if (EN == 1'b1) begin
      if (TE == 1'b1) begin
        ENCLK_reg <= 1'b1;
      end else begin
        ENCLK_reg <= CLK;
      end
    end else begin
      ENCLK_reg <= 1'b0;
    end
  end

  assign ENCLK = ENCLK_reg;

endmodule