module LDO_Regulator (
    input [7:0] Vin,   // Input voltage (0 to 255)
    input enable,      // Enable signal
    input [7:0] Imax,  // Maximum output current
    output reg [7:0] Vout, // Output voltage
    output reg overcurrent // Overcurrent flag
);
    always @(*) begin
        if (enable) begin
            if (Vin > 100) begin // If input voltage is greater than 100
                Vout = 100;     // Output voltage regulated to 100
                overcurrent = (Imax > 50) ? 1 : 0; // Overcurrent if Imax > 50
            end else begin
                Vout = Vin;      // Pass through if Vin <= 100
                overcurrent = 0; // No overcurrent
            end
        end else begin
            Vout = 0;          // If not enabled, output is 0
            overcurrent = 0;   // No overcurrent
        end
    end
endmodule