module SwitchingRegulator (
    input wire [7:0] Vin,    // Input voltage
    input wire [7:0] Vout,   // Output voltage
    input wire [7:0] Vref,   // Reference voltage
    output reg PWM           // PWM output
);
    always @(*) begin
        if (Vout < Vref) begin
            PWM = 1; // Turn on the switch
        end else begin
            PWM = 0; // Turn off the switch
        end
    end
endmodule