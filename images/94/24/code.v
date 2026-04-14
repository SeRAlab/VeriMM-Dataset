module top_module(
  input reset,
  input clk,
  input [7:0] R1,
  input [7:0] R2,
  input [7:0] C,
  output pulse
);reg [31:0] counter;
  reg pulse_reg;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      counter <= 0;
      pulse_reg <= 0;
    end else begin
      if (counter == 0) begin
        pulse_reg <= ~pulse_reg;
        counter <= (R1 + R2) * C;
      end else begin
        counter <= counter - 1;
      end
    end
  end

  assign pulse = pulse_reg;

endmodule