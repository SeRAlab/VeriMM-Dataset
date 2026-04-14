module top_module(
  input CLK,
  input EN,
  input TE,
  output ENCLK
);reg latch_out;

  always @(*) begin
    if (EN) begin
      latch_out <= CLK;
    end else if (TE) begin
      latch_out <= TE;
    end else begin
      latch_out <= 1'b0;
    end
  end

  assign ENCLK = latch_out;

endmodule