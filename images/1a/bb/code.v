module switching_regulator (
    input wire [7:0] Vin,    // Input voltage (8 bits)
    input wire [7:0] Vref,   // Reference voltage (8 bits)
    output reg PWM_OUT       // PWM output
);
    always @(*) begin
        if (Vin > Vref) begin
            PWM_OUT = 1; // High when Vin is greater than Vref
        end else begin
            PWM_OUT = 0; // Low otherwise
        end
    end
endmodule