module SNPS_CLOCK_GATE_HIGH_d_ff_en_W64_0_32 ( CLK, EN, ENCLK, TE );
  input CLK, EN, TE;
  output ENCLK;

  // Implement a D flip-flop with enable
  reg D, Q;
  always @(posedge CLK) begin
    if (EN) begin
      Q <= D;
    end
  end

  // Implement a transparent latch
  reg TL;
  always @(posedge CLK) begin
    if (TE) begin
      TL <= Q;
    end
  end

  // Implement the clock gate
  always @(posedge CLK) begin
    if (TE) begin
      ENCLK <= 1'b1;
    end else if (EN) begin
      ENCLK <= CLK;
    end else begin
      ENCLK <= 1'b0;
    end
  end
endmodule