module LDO (
    input wire Vref,       // Reference voltage input
    input wire Vin,        // Supply voltage input
    input wire Vdrop,      // Dropout voltage
    input wire enable,      // Enable signal
    output reg Vout        // Output voltage
);
    always @(Vref, Vin, Vdrop, enable) begin
        if (enable) begin
            if (Vin > Vdrop) begin
                Vout <= Vref;
            end else begin
                Vout <= 0; // Output is 0 if Vin is not sufficient
            end
        end else begin
            Vout <= 0; // Output is 0 when disabled
        end
    end
endmodule