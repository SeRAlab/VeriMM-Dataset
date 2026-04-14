module clock_gate (
  input CLK,
  input EN,
  input TE,
  input RST,
  output reg ENCLK
);

  always @(posedge CLK) begin
    if (RST) begin
      ENCLK <= 0;
    end else if (TE) begin
      ENCLK <= EN;
    end
  end

endmodule