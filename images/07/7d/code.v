module switching_regulator (
    input wire clk,
    input wire rst,
    input wire [7:0] vin,       // Input voltage (0 to 255, representing 0V to 5V)
    output reg pwm_out          // PWM output to control the switch
);

    reg [7:0] vout;             // Output voltage (to be controlled)
    reg [7:0] error;           // Error signal
    reg [7:0] duty_cycle;       // Duty cycle for PWM

    parameter TARGET_VOLTAGE = 8'd128; // 5V target represented in 0-255 scale

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            vout <= 8'd0;
            duty_cycle <= 8'd0;
            pwm_out <= 1'b0;
        end else begin
            // Calculate error
            error <= TARGET_VOLTAGE - vout;

            // Simple proportional control for PWM duty cycle
            duty_cycle <= duty_cycle + (error >> 1); // Adjust duty cycle based on error

            // Limit duty cycle
            if (duty_cycle > 8'd255) duty_cycle <= 8'd255;

            // Update PWM output based on the duty cycle
            pwm_out <= (duty_cycle > 128) ? 1'b1 : 1'b0; // Simple PWM logic
        end
    end
endmodule