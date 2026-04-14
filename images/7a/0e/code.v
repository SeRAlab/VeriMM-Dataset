module edge_detector(
  input clk,
  input rst_n,
  input sig_in,
  output reg pulse_out
);

  reg sig_in_d;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      sig_in_d <= 1'b0;
      pulse_out <= 1'b0;
    end else begin
      if (sig_in & ~sig_in_d)
        pulse_out <= 1'b1;
      else
        pulse_out <= 1'b0;

      sig_in_d <= sig_in;
    end
  end

endmodule