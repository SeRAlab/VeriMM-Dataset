module top_module(
  input async_reset_neg,
  input fb_clk,
  input [31:0] adg_int,
  input fb_tag_r,
  input fb_we_r,
  output reg output_signal
);always @(*) begin
    if (async_reset_neg == 0 && fb_clk == 1 && adg_int >= 0 && fb_tag_r == 1 && fb_we_r == 0) begin
      output_signal <= 1;
    end else begin
      output_signal <= 0;
    end
  end

endmodule