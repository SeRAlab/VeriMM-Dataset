module linear_voltage_regulator (
    input [4:0] vin, // 5-bit input voltage
    output reg [4:0] vout // 5-bit output voltage
);

always @(*) begin
    if (vin > 5'b01111) // If input voltage is greater than 15
        vout = 5'b01111; // Clamp output to 15
    else
        vout = vin; // Otherwise output is equal to input
end

endmodule