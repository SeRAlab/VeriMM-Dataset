module top_module(
  input dir,
  input step,
  input [7:0] duty_cycle,
  output reg enable,    // Changed to reg
  output reg step_dir,  // Changed to reg
  output reg [3:0] step_pulse
);reg pwm_out;
  reg hbridge_dir;

  // PWM controller
  always @ (posedge step) begin
    if (duty_cycle >= 100) begin
      pwm_out <= 1;
    end else if (duty_cycle == 0) begin
      pwm_out <= 0;
    end else begin
      pwm_out <= (step % (100 / duty_cycle)) == 0;
    end
  end

  // H-bridge driver
  always @ (dir, pwm_out) begin
    if (dir) begin
      hbridge_dir <= 1;
    end else begin
      hbridge_dir <= 0;
    end
    enable <= 1;
    step_dir <= hbridge_dir;
  end

  // Stepper motor controller
  always @ (posedge step) begin
    if (step_pulse == 4'b0001) begin
      step_pulse <= 4'b0010;
    end else if (step_pulse == 4'b0010) begin
      if (hbridge_dir) begin
        step_pulse <= 4'b0100;
      end else begin
        step_pulse <= 4'b0001;
      end
    end else if (step_pulse == 4'b0100) begin
      step_pulse <= 4'b1000;
    end else begin
      if (hbridge_dir) begin
        step_pulse <= 4'b0001;
      end else begin
        step_pulse <= 4'b0010;
      end
    end
  end

endmodule