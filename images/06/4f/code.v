module switching_regulator (
    input wire enable,
    input wire pwm,
    output reg vout
);
    always @(*) begin
        if (enable) begin
            // Simple PWM control logic
            vout = pwm; // Assuming pwm signal directly controls the output voltage
        end else begin
            vout = 0; // If not enabled, output is 0
        end
    end
endmodule