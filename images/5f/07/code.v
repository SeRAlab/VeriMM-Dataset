module top_module(
  input pwm_freq,
  input pwm_duty,
  input dir,
  input brake,
  input step,
  input speed,
  output reg [3:0] hbridge_ctrl, // Change to reg type
  output pwm_out,
  output reg [3:0] stepper_ctrl // Change to reg type
);// PWM motor control block
  reg [15:0] pwm_counter;
  reg pwm_out_reg;
  
  always @(posedge pwm_freq) begin
    if (pwm_counter == 16'd0) begin
      pwm_out_reg <= 1'b1;
      pwm_counter <= pwm_duty * 16'd65535;
    end else if (pwm_counter == pwm_duty * 16'd65535) begin
      pwm_out_reg <= 1'b0;
      pwm_counter <= 16'd0;
    end else begin
      pwm_out_reg <= pwm_out_reg;
      pwm_counter <= pwm_counter + 16'd1;
    end
  end
  
  assign pwm_out = pwm_out_reg & dir;

  // H-bridge motor control block
  always @(*) begin
    case ({dir, brake})
      2'b00: hbridge_ctrl = 4'b0101; // Forward
      2'b01: hbridge_ctrl = 4'b0001; // Brake
      2'b10: hbridge_ctrl = 4'b1010; // Reverse
      2'b11: hbridge_ctrl = 4'b0001; // Brake
    endcase
  end

  // Stepper motor control block
  reg [3:0] stepper_state;
  
  always @(posedge step) begin
    if (dir == 1'b1) begin
      case (stepper_state)
        4'b0001: stepper_ctrl <= 4'b1000;
        4'b0010: stepper_ctrl <= 4'b0100;
        4'b0100: stepper_ctrl <= 4'b0010;
        4'b1000: stepper_ctrl <= 4'b0001;
      endcase
    end else begin
      case (stepper_state)
        4'b0001: stepper_ctrl <= 4'b0001;
        4'b0010: stepper_ctrl <= 4'b0010;
        4'b0100: stepper_ctrl <= 4'b0100;
        4'b1000: stepper_ctrl <= 4'b1000;
      endcase
    end
    if (speed == 1'b1) begin
      case (stepper_state)
        4'b0001: stepper_state <= 4'b0010;
        4'b0010: stepper_state <= 4'b0100;
        4'b0100: stepper_state <= 4'b1000;
        4'b1000: stepper_state <= 4'b0001;
      endcase
    end else begin
      case (stepper_state)
        4'b0001: stepper_state <= 4'b1000;
        4'b0010: stepper_state <= 4'b0001;
        4'b0100: stepper_state <= 4'b0010;
        4'b1000: stepper_state <= 4'b0100;
      endcase
    end
  end

endmodule