module top_module(
  input wire clk,
  input wire in_trigger,
  input wire in_reset,
  input wire [7:0] pulse_duration,
  output reg out_pulse  // Change to reg type
);reg [7:0] counter;
  reg pulse_on;

  always @(posedge clk) begin
    if (in_reset) begin
      counter <= 0;
      pulse_on <= 0;
      out_pulse <= 0;
    end else begin
      if (in_trigger) begin
        counter <= pulse_duration;
        pulse_on <= 1;
        out_pulse <= 1;
      end else if (counter > 0) begin
        counter <= counter - 1;
        out_pulse <= pulse_on;
      end else begin
        pulse_on <= 0;
        out_pulse <= 0;
      end
    end
  end

endmodule