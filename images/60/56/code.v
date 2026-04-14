module top_module(
  input step,
  input direction,
  input pwm,
  input clk,                // Added clk input for clock signal
  output reg Aplus,         // Changed output to reg for Aplus
  output reg Aminus,        // Changed output to reg for Aminus
  output pwm_out
);parameter steps_per_revolution = 200; // number of steps per revolution for the stepper motor
parameter pwm_frequency = 100; // frequency of the PWM signal for the H-bridge driver

reg [7:0] count;
reg [7:0] pwm_count;
reg pwm_out_reg;

always @(posedge clk) begin
  if (count == steps_per_revolution) begin
    count <= 0;
  end else if (step) begin
    count <= count + 1;
  end
  
  if (pwm_count == pwm_frequency) begin
    pwm_count <= 0;
  end else begin
    pwm_count <= pwm_count + 1;
  end
  
  if (pwm_count < pwm) begin
    pwm_out_reg <= 1;
  end else begin
    pwm_out_reg <= 0;
  end
end

assign pwm_out = pwm_out_reg;

always @(count or direction) begin  // Updated sensitivity list
  if (direction) begin
    if (count < steps_per_revolution/2) begin
      Aplus <= 1;
      Aminus <= 0;
    end else begin
      Aplus <= 0;
      Aminus <= 1;
    end
  end else begin
    if (count < steps_per_revolution/2) begin
      Aplus <= 0;
      Aminus <= 1;
    end else begin
      Aplus <= 1;
      Aminus <= 0;
    end
  end
end

endmodule