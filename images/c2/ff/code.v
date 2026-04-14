module clock_gate (CLK, EN, TE, ENCLK);
  input CLK, EN, TE;
  output ENCLK;

  reg ENCLK;

  always @ (posedge CLK) begin
    if (EN && TE) begin
      ENCLK <= 1'b1;
    end else begin
      ENCLK <= 1'b0;
    end
  end

endmodule