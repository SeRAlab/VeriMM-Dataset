module pwm_controller(
    input clk,                   // Clock signal
    input reset,                 // Reset signal
    input [7:0] setpoint,       // Desired voltage level (0 to 255)
    input [7:0] feedback,       // Measured voltage level (0 to 255)
    output reg pwm_signal        // PWM output signal
);

reg [7:0] duty_cycle;          // Duty cycle for PWM signal
reg [7:0] error;               // Error signal

// Update duty cycle based on error
always @(posedge clk or posedge reset) begin
    if (reset) begin
        duty_cycle <= 8'd0;
        pwm_signal <= 1'b0;
    end else begin
        error <= setpoint - feedback; // Calculate error
        // Simple proportional control
        if (error > 8'd0) begin
            duty_cycle <= (error > 8'd255) ? 8'd255 : error; // Limit duty cycle
        end else begin
            duty_cycle <= 8'd0;
        end
        // Generate PWM signal
        pwm_signal <= (duty_cycle > (duty_cycle >> 1)) ? 1'b1 : 1'b0; 
    end
end

endmodule