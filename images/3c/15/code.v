module huffman_encoder (
    input [3:0] char,
    output reg [2:0] code
);
    always @(*) begin
        case (char)
            4'b0000: code = 3'b000; // A
            4'b0001: code = 3'b001; // B
            4'b0010: code = 3'b010; // C
            4'b0011: code = 3'b011; // D
            4'b0100: code = 3'b100; // E
            4'b0101: code = 3'b101; // F
            4'b0110: code = 3'b110; // G
            4'b0111: code = 3'b111; // H
            default: code = 3'bxxx; // undefined
        endcase
    end
endmodule