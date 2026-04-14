module top_module(
  input CLK,
  input EN,
  input TE,
  output reg ENCLK
);reg gated_clk;

  always @(posedge CLK) begin
    if (EN && !TE) begin
      gated_clk <= 1'b1;
    end else begin
      gated_clk <= 1'b0;
    end
  end

  always @(posedge CLK) begin
    if (gated_clk) begin
      ENCLK <= 1'b1; // Clock enabled
    end else begin
      ENCLK <= 1'b0; // Clock disabled
    end
  end

endmodule