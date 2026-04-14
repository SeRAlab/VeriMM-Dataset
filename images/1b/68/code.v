module LDO (
    input wire [4:0] Vin,   // 5-bit input voltage
    output reg [4:0] Vout   // 5-bit output voltage
);

always @(*) begin
    if (Vin >= 5'b10000)    // If Vin is greater than or equal to 16 (10000 in binary)
        Vout = 5'b01000;    // Output is 8 (01000 in binary)
    else
        Vout = 5'b00100;    // Output is 4 (00100 in binary)
end

endmodule