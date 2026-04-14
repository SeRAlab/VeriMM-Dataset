module buck_converter (
    input [7:0] Vin, // Input voltage (8 bits)
    input [7:0] D,   // Duty cycle (8 bits)
    output reg [7:0] Vout // Output voltage (8 bits)
);
    always @(*) begin
        Vout = (Vin * D) >> 8; // Calculate Vout = Vin * D / 256
    end
endmodule