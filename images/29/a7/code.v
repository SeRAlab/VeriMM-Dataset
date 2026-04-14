module voltage_regulator (
    input [3:0] Vin, // 4-bit input representing Vin in 0.3125V increments
    output reg [3:0] Vout // 4-bit output representing Vout in 0.3125V increments
);
    always @(*) begin
        if (Vin >= 4'd11) // 3.3V = 11 in 0.3125V increments
            Vout = 4'd11; // Output 3.3V
        else
            Vout = Vin; // Output Vin
    end
endmodule