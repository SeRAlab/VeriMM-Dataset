module huffman_encoder (
    input [7:0] in_char,
    output reg [2:0] encoded_output
);
    always @(*) begin
        case (in_char)
            8'b01000001: encoded_output = 3'b000; // A
            8'b01000010: encoded_output = 3'b001; // B
            8'b01000011: encoded_output = 3'b010; // C
            8'b01000100: encoded_output = 3'b011; // D
            8'b01000101: encoded_output = 3'b100; // E
            8'b01000110: encoded_output = 3'b101; // F
            8'b01000111: encoded_output = 3'b110; // G
            8'b01001000: encoded_output = 3'b111; // H
            default: encoded_output = 3'bxxx; // Undefined
        endcase
    end
endmodule