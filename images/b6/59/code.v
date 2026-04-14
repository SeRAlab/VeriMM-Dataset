module top_module(
  input CLK,
  input EN,
  input TE,
  output reg ENCLK  // Changed to output reg
);reg last_clk;
  reg last_en;
  reg last_te;

  always @ (posedge CLK) begin
    if (EN & TE & ~last_en & last_te) begin
      ENCLK <= 1;
    end else begin
      ENCLK <= 0;
    end
    last_clk <= CLK;
    last_en <= EN;
    last_te <= TE;
  end

endmodule