module linear_voltage_regulator (
    input [4:0] vin,      // 5-bit input voltage
    output reg [4:0] vout // 5-bit output voltage
);

parameter REFERENCE_VOLTAGE = 5'b01010; // Reference voltage (10 in decimal)

always @(*) begin
    if (vin > REFERENCE_VOLTAGE) 
        vout = REFERENCE_VOLTAGE; // Output is reference voltage if input is higher
    else 
        vout = vin; // Output is input voltage otherwise
end

endmodule