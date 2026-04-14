module SNPS_CLOCK_GATE_HIGH_RegisterAdd_W13 ( CLK, EN, ENCLK, TE );
  input CLK, EN, TE;
  output ENCLK;

  reg ENCLK;

  always @ (posedge CLK) begin
    if(EN && TE) begin
      ENCLK <= 1'b0;
    end
    else begin
      ENCLK <= 1'b1;
    end
  end

endmodule