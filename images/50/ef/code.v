module top_module(
  input               clk, // Clock signal
  input               rst_n, // Active low reset
  input [3:0]         data_in, // 4-bit input signal
  output reg          rise_detect, // Rising edge detection output
  output reg          fall_detect, // Falling edge detection output
  output reg          led_rise, // LED for rising edge detection
  output reg          led_fall // LED for falling edge detection
);reg [3:0] prev_data; // Previous input signal value
  reg [3:0] curr_data; // Current input signal value
  reg        d_ff; // D flip-flop output

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      prev_data <= 4'b0;
      curr_data <= 4'b0;
      d_ff <= 1'b0;
      rise_detect <= 1'b0;
      fall_detect <= 1'b0;
      led_rise <= 1'b0;
      led_fall <= 1'b0;
    end
    else begin
      prev_data <= curr_data;
      curr_data <= data_in;
      d_ff <= curr_data[0];
      rise_detect <= (d_ff ^ prev_data[0]) & ~d_ff;
      fall_detect <= (d_ff ^ prev_data[0]) & d_ff;
      led_rise <= rise_detect;
      led_fall <= fall_detect;
    end
  end

endmodule