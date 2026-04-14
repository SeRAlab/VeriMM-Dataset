module voltage_regulator(
    input clk,
    input reset,
    input [7:0] Vin,      // Input voltage (0 to 5V in 8-bit format)
    input [7:0] Vdesired, // Desired output voltage (0 to 5V in 8-bit format)
    output reg PWM_out    // PWM output signal to control the switch
);

reg [7:0] Vout;           // Current output voltage
reg [7:0] error;          // Error signal
reg [7:0] duty_cycle;     // Duty cycle for PWM control

always @(posedge clk or posedge reset) begin
    if (reset) begin
        Vout <= 0;
        PWM_out <= 0;
        duty_cycle <= 0;
    end else begin
        // Calculate error
        error <= Vdesired - Vout;
        
        // Adjust duty cycle based on error (simple proportional control)
        duty_cycle <= duty_cycle + (error >> 1); // Shift for scaling
        
        // Limit duty cycle to a maximum value
        if (duty_cycle > 255) duty_cycle <= 255;
        else if (duty_cycle < 0) duty_cycle <= 0;
        
        // Generate PWM output
        PWM_out <= (Vin > duty_cycle) ? 1 : 0;
        
        // Update output voltage (for simulation purposes)
        Vout <= (PWM_out) ? Vout + 1 : Vout - 1; // Simple model of voltage change
    end
end

endmodule