module top_module(
  input clk,
  input reset,
  input in,
  output reg rising_edge,
  output reg falling_edge
);reg prev_in;

  always @(posedge clk, posedge reset) begin
    if (reset) begin
      rising_edge <= 1'b0;
      falling_edge <= 1'b0;
      prev_in <= 1'b0;
    end else begin
      if (in != prev_in) begin
        if (in > prev_in) begin
          rising_edge <= 1'b1;
          falling_edge <= 1'b0;
        end else begin
          rising_edge <= 1'b0;
          falling_edge <= 1'b1;
        end
      end else begin
        rising_edge <= 1'b0;
        falling_edge <= 1'b0;
      end
      prev_in <= in;
    end
  end

endmodule