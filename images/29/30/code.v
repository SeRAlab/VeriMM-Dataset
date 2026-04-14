module voltage_regulator (
    input [7:0] Vin,  // 8-bit input voltage
    output reg [7:0] Vout // 8-bit output voltage
);

always @(*) begin
    if (Vin >= 8'd5) 
        Vout = 8'd5; // Output 5V if Vin is greater than or equal to 5V
    else 
        Vout = Vin; // Otherwise, output Vin
end

endmodule