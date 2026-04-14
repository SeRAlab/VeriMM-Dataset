module top_module(
  input clk,
  input rst,
  input [7:0] ctrl_in,
  output [7:0] servo_out
);parameter FREQ = 50; // PWM frequency in Hz

reg [7:0] duty_cycle = 8'h7F; // default duty cycle

reg [31:0] counter = 0; // counter for PWM frequency

always @(posedge clk or posedge rst) begin
  if (rst) begin
    counter <= 0;
    duty_cycle <= 8'h7F;
  end else begin
    counter <= counter + 1;
    if (counter == (50000000 / (FREQ * 256))) begin // 50 MHz clock
      counter <= 0;
      duty_cycle <= ctrl_in;
    end
  end
end

assign servo_out = (counter < (duty_cycle << 8)); // generate PWM signal

endmodule