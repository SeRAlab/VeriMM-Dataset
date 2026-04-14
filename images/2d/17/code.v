module LDO (
    input wire [7:0] Vin,     // Input voltage
    input wire [7:0] Vref,    // Reference voltage
    output reg [7:0] Vout,    // Output voltage
    output reg OverVoltage,    // Over Voltage indicator
    output reg UnderVoltage    // Under Voltage indicator
);
    
    always @(*) begin
        if (Vin > Vref) begin
            Vout = Vref; // Regulate to Vref
        end else begin
            Vout = Vin; // Follow input voltage
        end
        
        // Check OverVoltage and UnderVoltage
        if (Vout > (Vref + (Vref / 10))) begin
            OverVoltage = 1'b1; // Over Voltage condition
        end else begin
            OverVoltage = 1'b0;
        end
        
        if (Vout < (Vref - (Vref / 10))) begin
            UnderVoltage = 1'b1; // Under Voltage condition
        end else begin
            UnderVoltage = 1'b0;
        end
    end
endmodule