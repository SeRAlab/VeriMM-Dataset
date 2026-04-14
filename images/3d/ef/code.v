module voltage_regulator (
    input [7:0] V_ref,  // Reference voltage
    input [7:0] V_in,   // Input voltage
    output reg PWM       // PWM output signal
);
    always @(*) begin
        if (V_in > V_ref) begin
            PWM = 1; // Increase duty cycle
        end else begin
            PWM = 0; // Decrease duty cycle
        end
    end
endmodule