module switching_regulator(
    input clk,
    input reset,
    input [7:0] vin,      // Input voltage
    input [7:0] vref,     // Reference voltage
    output reg pwm_out     // PWM output signal
);
    reg [7:0] duty_cycle;
    reg [7:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 8'b0;
            pwm_out <= 1'b0;
            duty_cycle <= 8'b0;
        end else begin
            if (vin > vref) begin
                duty_cycle <= duty_cycle - 1; // Decrease duty cycle
            end else begin
                duty_cycle <= duty_cycle + 1; // Increase duty cycle
            end
            
            counter <= counter + 1;
            if (counter < duty_cycle) begin
                pwm_out <= 1'b1; // Set PWM high
            end else begin
                pwm_out <= 1'b0; // Set PWM low
            end
            
            if (counter == 8'd255) begin
                counter <= 8'b0; // Reset counter after full cycle
            end
        end
    end
endmodule