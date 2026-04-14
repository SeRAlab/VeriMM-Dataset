module LDO_Regulator (
    input [7:0] Vin,      // Input voltage
    input [7:0] Vref,     // Reference voltage
    output reg [7:0] Vout // Output voltage
);
    parameter DROPOUT_V = 8'd10; // Dropout voltage

    always @(*) begin
        if (Vin - DROPOUT_V <= Vref) begin
            Vout = Vin - DROPOUT_V; // Output regulated to Vin - DROPOUT_V
        end else begin
            Vout = Vref; // Output regulated to reference voltage
        end
    end
endmodule