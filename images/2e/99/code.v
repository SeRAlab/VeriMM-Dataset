module huffman_encoder (
    input [2:0] char, // Assuming 3-bit input for 8 characters
    output reg [3:0] code // 4-bit output for Huffman codes
);
    always @(*) begin
        case (char)
            3'b000: code = 4'b000; // Character 0
            3'b001: code = 4'b001; // Character 1
            3'b010: code = 4'b010; // Character 2
            3'b011: code = 4'b011; // Character 3
            3'b100: code = 4'b100; // Character 4
            3'b101: code = 4'b101; // Character 5
            3'b110: code = 4'b110; // Character 6
            3'b111: code = 4'b111; // Character 7
            default: code = 4'bxxxx; // Undefined behavior
        endcase
    end
endmodule