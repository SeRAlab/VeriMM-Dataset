module encoder_8_to_3 (
    input [7:0] I,
    output reg [2:0] Y
);
    always @(*) begin
        case (I)
            8'b00000001: Y = 3'b000; // I0
            8'b00000010: Y = 3'b001; // I1
            8'b00000100: Y = 3'b010; // I2
            8'b00001000: Y = 3'b011; // I3
            8'b00010000: Y = 3'b100; // I4
            8'b00100000: Y = 3'b101; // I5
            8'b01000000: Y = 3'b110; // I6
            8'b10000000: Y = 3'b111; // I7
            default: Y = 3'b000; // None active
        endcase
    end
endmodule