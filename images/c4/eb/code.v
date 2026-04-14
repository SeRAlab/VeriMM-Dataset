module clock_gate(
  input CLK, // clock signal
  input EN, // enable signal
  input TE, // test enable signal
  output ENCLK // gated clock signal
);

  reg gated_clk;
  
  always @(*) begin
    if (TE) begin
      gated_clk = 1;
    end else if (EN) begin
      gated_clk = CLK;
    end else begin
      gated_clk = 0;
    end
  end

  assign ENCLK = gated_clk;

endmodule