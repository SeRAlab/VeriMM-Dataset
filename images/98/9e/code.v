module top_module(
  input clk_in,
  input signed [31:0] phase_shift,
  output clk_out
);reg delayed_clk;
  reg [31:0] delay_count = 0;

  always @(posedge clk_in) begin
    if (phase_shift > 0) begin
      if (delay_count < phase_shift) begin
        delay_count <= delay_count + 1;
        delayed_clk <= 0;
      end else begin
        delayed_clk <= 1;
      end
    end else if (phase_shift < 0) begin
      if (delay_count < -phase_shift) begin
        delay_count <= delay_count + 1;
        delayed_clk <= 1;
      end else begin
        delayed_clk <= 0;
      end
    end else begin
      delayed_clk <= clk_in;
    end
  end

  assign clk_out = delayed_clk ? delayed_clk : clk_in;

endmodule