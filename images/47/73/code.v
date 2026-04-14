module top_module(
  input CLK, EN, TE,
  output reg ENCLK
);reg gated_clk;

  always @(posedge CLK) begin
    if (EN && TE) begin
      gated_clk <= 1'b1;
    end else begin
      gated_clk <= 1'b0;
    end
  end

  always @(posedge CLK) begin
    if (EN && TE) begin
      ENCLK <= gated_clk;
    end
  end

endmodule