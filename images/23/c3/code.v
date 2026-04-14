module switching_regulator (
    input clk,
    input reset,
    input [7:0] desired_voltage,
    input [7:0] measured_voltage,
    output reg pwm_signal
);
    reg [7:0] error;
    reg [7:0] duty_cycle;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            duty_cycle <= 8'd0;
            pwm_signal <= 1'b0;
        end else begin
            error <= desired_voltage - measured_voltage;
            duty_cycle <= error; // Proportional control
            
            // Generate PWM signal
            if (duty_cycle > 8'd255)
                duty_cycle <= 8'd255; // Clamp to maximum
            else if (duty_cycle < 8'd0)
                duty_cycle <= 8'd0; // Clamp to minimum
            
            pwm_signal <= (clk % 256 < duty_cycle) ? 1'b1 : 1'b0; // Simple PWM generation
        end
    end
endmodule