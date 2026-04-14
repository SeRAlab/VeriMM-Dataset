module LDO (
    input wire [4:0] Vref,    // Reference voltage
    input wire [4:0] Vin,     // Input voltage
    input wire enable,         // Control signal
    output reg [4:0] Vout     // Output voltage
);
    always @(*) begin
        if (enable) begin
            if (Vin >= Vref) begin
                Vout = Vref;   // Output is Vref if Vin is high enough
            end else begin
                Vout = 0;      // Output is 0 if Vin is too low
            end
        end else begin
            Vout = 0;          // Output is 0 if enable is low
        end
    end
endmodule