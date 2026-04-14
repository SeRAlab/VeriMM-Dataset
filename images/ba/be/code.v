module top_module(CLK, EN, TE, ENCLK);input CLK, EN, TE;
  output ENCLK;

  reg gated_clk;
  reg d_ff_out;

  always @(posedge CLK) begin
    if (EN && TE) begin
      gated_clk <= CLK;
    end else begin
      gated_clk <= 1'b0;
    end
  end

  always @(posedge CLK) begin
    if (EN) begin
      d_ff_out <= gated_clk;
    end
  end

  assign ENCLK = d_ff_out;

endmodule