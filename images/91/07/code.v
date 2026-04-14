module top_module(
  input clk,
  input rst,
  input [1:0] motor_type,
  input dir,
  input [7:0] speed,
  input step,
  output reg pwm,                // Change output to reg type
  output reg [1:0] control,
  output reg [3:0] step_signals
);// Define the states for the state machine
  parameter IDLE = 2'b00;
  parameter PWM = 2'b01;
  parameter H_BRIDGE = 2'b10;
  parameter STEPPER = 2'b11;
  
  // Define the state register and next state logic
  reg [1:0] state, next_state;
  always @(posedge clk, posedge rst) begin
    if (rst) begin
      state <= IDLE;
    end else begin
      state <= next_state;
    end
  end
  
  // Define the state transition logic based on the motor type selector
  always @(*) begin
    case (motor_type)
      2'b00: next_state = IDLE;
      2'b01: next_state = PWM;
      2'b10: next_state = H_BRIDGE;
      2'b11: next_state = STEPPER;
      default: next_state = IDLE;
    endcase
  end
  
  // Define the control logic for each motor type
  always @(posedge clk) begin
    case (state)
      IDLE: begin
        pwm <= 1'b0;                // Initialize pwm to 0 in IDLE state
        control <= 2'b00;
        step_signals <= 4'b0000;
      end
      PWM: begin
        pwm <= speed[7];           // Assign value to pwm based on speed
        control <= {dir, ~dir};
        step_signals <= 4'b0000;
      end
      H_BRIDGE: begin
        pwm <= 1'b0;
        control <= {dir, ~dir};
        step_signals <= 4'b0000;
      end
      STEPPER: begin
        pwm <= 1'b0;
        control <= 2'b00;
        if (step) begin
          case (step_signals)
            4'b0000: step_signals <= 4'b0001;
            4'b0001: step_signals <= 4'b0010;
            4'b0010: step_signals <= 4'b0100;
            4'b0100: step_signals <= 4'b1000;
            4'b1000: step_signals <= 4'b0001;
            default: step_signals <= 4'b0000;
          endcase
        end
      end
      default: begin
        pwm <= 1'b0;                // Ensure pwm is defined in default
        control <= 2'b00;
        step_signals <= 4'b0000;
      end
    endcase
  end
  
endmodule