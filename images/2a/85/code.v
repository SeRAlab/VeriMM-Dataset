module switching_regulator (
    input clk,
    input reset,
    input [7:0] pwm_in,       // PWM signal as a duty cycle (0-255)
    output reg [7:0] v_out    // Output voltage (0-255)
);
    reg [7:0] v_ref = 8'd128; // Reference voltage (fixed to mid-scale)
    reg signed [8:0] error;   // Error signal (signed for potential negative values)
    reg signed [8:0] integral; // Integral component for PID
    reg signed [8:0] derivative; // Derivative component for PID
    reg [7:0] previous_error; // Previous error for derivative calculation

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            v_out <= 8'd0;
            integral <= 8'd0;
            previous_error <= 8'd0;
        end else begin
            // Calculate error
            error = v_ref - pwm_in;

            // Calculate integral (simple sum, beware of overflow)
            integral = integral + error;

            // Calculate derivative
            derivative = error - previous_error;

            // PID control (Kp=1, Ki=1, Kd=1 for simplicity)
            v_out = pwm_in + error + integral[7:0] + derivative[7:0];

            // Update previous error
            previous_error = error[7:0];
        end
    end
endmodule