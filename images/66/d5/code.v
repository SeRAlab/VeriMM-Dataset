module top_module(
  input CLK,
  input EN,
  input TE,
  output ENCLK
);reg gated_clk;
  always @(*) begin
    if (EN && TE) begin
      gated_clk <= CLK;
    end else begin
      gated_clk <= 1'b0;
    end
  end

  reg dff_en;
  always @(*) begin
    if (EN && TE) begin
      dff_en <= 1'b1;
    end else begin
      dff_en <= 1'b0;
    end
  end

  reg dff_out;
  always @(posedge gated_clk) begin
    if (dff_en) begin
      dff_out <= ~dff_out;
    end
  end

  assign ENCLK = dff_out;

endmodule