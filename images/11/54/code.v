module LDO (
    input wire Vin,      // Input voltage
    input wire Vctrl,    // Control signal
    output reg Vout      // Output voltage
);
    parameter Vdrop = 1; // Dropout voltage of 1V

    always @(*) begin
        if (Vctrl) begin
            Vout = Vin - Vdrop; // Output is Vin - Vdrop when Vctrl is high
        end else begin
            Vout = 0;            // Output is 0 when Vctrl is low
        end
    end
endmodule