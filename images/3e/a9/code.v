module switching_regulator(
    input wire clk,
    input wire rst_n,
    input wire [7:0] vin,          // Input voltage
    output reg [7:0] vout,        // Output voltage
    output reg pwm_signal         // PWM output
);

    reg [7:0] vref = 8'd128;       // Reference voltage (desired output)
    reg [7:0] duty_cycle;           // Duty cycle for PWM

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            vout <= 8'd0;
            pwm_signal <= 1'b0;
            duty_cycle <= 8'd0;
        end else begin
            // Simple proportional control
            if (vin > vref) begin
                duty_cycle <= duty_cycle - 1;
            end else begin
                duty_cycle <= duty_cycle + 1;
            end

            // PWM signal generation
            pwm_signal <= (duty_cycle > vin) ? 1'b1 : 1'b0;
            vout <= vin * duty_cycle / 255; // Scaled output voltage
        end
    end

endmodule