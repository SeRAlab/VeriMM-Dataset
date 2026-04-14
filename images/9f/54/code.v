module top_module(
  input clk,
  input [7:0] data,
  output pwm_out
);parameter clk_freq = 50_000_000; // 50 MHz
parameter pwm_freq = 10_000; // 10 KHz
parameter resolution = 8; // 8-bit duty cycle resolution

reg [resolution-1:0] duty_cycle;
reg [31:0] counter;
wire comparator_out;

assign pwm_out = comparator_out;

always @(posedge clk) begin
  counter <= counter + 1;
  if (counter >= ((clk_freq/pwm_freq)/2)) begin
    counter <= 0;
  end
end

always @(posedge clk) begin
  duty_cycle <= data;
end

assign comparator_out = (counter < ((clk_freq/pwm_freq)*duty_cycle/(2**resolution)));

endmodule