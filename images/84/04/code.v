module top_module(
  input clk,
  input input_signal,
  output reg pulse_signal
);reg [31:0] counter = 0;
  reg pulse_active = 0;
  parameter PULSE_WIDTH = 10; // configurable pulse width
  
  always @(posedge clk) begin
    if (input_signal && !pulse_active) begin
      pulse_active = 1;
      counter = 0;
    end
    else if (pulse_active) begin
      if (counter < PULSE_WIDTH) begin
        pulse_signal <= 1;
        counter <= counter + 1;
      end
      else begin
        pulse_signal <= 0;
        pulse_active <= 0;
      end
    end
    else begin
      pulse_signal <= 0;
    end
  end
  
endmodule