module top_module(
  input pwm, // PWM signal
  input clk, // clock signal for PWM
  input [1:0] in, // input signals for H-bridge
  input ctrl, // control signal for H-bridge
  input step, // step signal for stepper motor
  input dir, // direction signal for stepper motor
  output reg pwm_out, // PWM output signal
  output reg [1:0] out, // output signals for H-bridge
  output reg [3:0] stepper_out // output signals for stepper motor
);parameter n = 200; // number of steps for stepper motor

reg [7:0] pwm_count = 8'd0; // counter for PWM duty cycle
reg [7:0] step_count = 8'd0; // counter for stepper motor steps
reg [3:0] stepper_pos = 4'b0000; // current position of stepper motor

always @(posedge clk) begin
  // PWM control block
  if (pwm_count < pwm) begin
    pwm_out <= 1'b1;
  end else begin
    pwm_out <= 1'b0;
  end
  pwm_count <= pwm_count + 1;
  
  // H-bridge control block
  case (ctrl)
    2'b00: out <= 2'b00;
    2'b01: out <= in;
    2'b10: out <= ~in;
    2'b11: out <= 2'b00;
  endcase
  
  // Stepper motor control block
  if (step_count >= n) begin
    step_count <= 8'd0;
    case (dir)
      1'b0: stepper_pos <= stepper_pos + 1;
      1'b1: stepper_pos <= stepper_pos - 1;
    endcase
  end else begin
    step_count <= step_count + 1;
  end
  
  case (stepper_pos)
    4'b0001: stepper_out <= 4'b0001;
    4'b0010: stepper_out <= 4'b0010;
    4'b0100: stepper_out <= 4'b0100;
    4'b1000: stepper_out <= 4'b1000;
    default: stepper_out <= 4'b0000;
  endcase
  
end

endmodule