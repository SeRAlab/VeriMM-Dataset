module TLATNTSCAX2TS (E, SE, CK, ECK, Q);
  input E, SE, CK, ECK;
  output Q;

  reg Q;

  always @(posedge CK, negedge ECK) begin
    if (!ECK) begin
      Q <= Q;
    end else if (SE) begin
      Q <= 1'b1;
    end else begin
      Q <= E;
    end
  end

endmodule

module SNPS_CLOCK_GATE_HIGH_d_ff_en_W64_0_3 (CLK, EN, ENCLK, TE);
  input CLK, EN, TE;
  output ENCLK;

  wire D;
  assign D = 1'b1;

  TLATNTSCAX2TS latch (.E(D), .SE(TE), .CK(CLK), .ECK(ENCLK), .Q(ENCLK));

endmodule