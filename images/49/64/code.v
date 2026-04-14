module top_module(clk, rst, note_on, saw_out, PWM);input clk, rst, note_on;
  input [7:0] saw_out;
  output reg PWM;

  reg [31:0] counter;
  reg [7:0] duty_cycle;

  always @(posedge clk) begin
    if (rst) begin
      counter <= 0;
      duty_cycle <= 0;
      PWM <= 0;
    end else begin
      counter <= counter + 1;
      if (counter == 500) begin // 1kHz PWM frequency
        counter <= 0;
        if (note_on) begin
          duty_cycle <= saw_out;
        end else begin
          duty_cycle <= 128; // 50% duty cycle
        end
      end
      if (duty_cycle > counter[7:0]) begin
        PWM <= 1;
      end else begin
        PWM <= 0;
      end
    end
  end
endmodule