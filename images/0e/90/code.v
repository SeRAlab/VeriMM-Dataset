module LDO_regulator(
    input [4:0] Vin,    // 5-bit input voltage
    output reg [4:0] Vout // 5-bit output voltage
);

    parameter THRESHOLD = 5'b00011; // 3V threshold (assuming 1V per bit)

    always @(*) begin
        if (Vin > THRESHOLD) begin
            Vout = Vin - 5'b00001; // Output is input minus 1
        end else begin
            Vout = 5'b00000; // Output is zero
        end
    end
endmodule