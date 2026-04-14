module adc_8bit (
    input [2:0] vin, // 3-bit input for voltage level
    output reg [7:0] vout // 8-bit output for digital representation
);
    always @(*) begin
        case(vin)
            3'b000: vout = 8'b00000000; // 0
            3'b001: vout = 8'b00111111; // 1/8
            3'b010: vout = 8'b01111111; // 2/8
            3'b011: vout = 8'b01111111; // 3/8
            3'b100: vout = 8'b11111111; // 4/8
            3'b101: vout = 8'b11111111; // 5/8
            3'b110: vout = 8'b11111111; // 6/8
            3'b111: vout = 8'b11111111; // 7/8
            default: vout = 8'b00000000; // default case
        endcase
    end
endmodule