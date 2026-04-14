module huffman_encoder (
    input [3:0] char_in,
    output reg [2:0] huffman_out
);
    always @(*) begin
        case (char_in)
            4'b0000: huffman_out = 3'b000; // Character 0
            4'b0001: huffman_out = 3'b001; // Character 1
            4'b0010: huffman_out = 3'b010; // Character 2
            4'b0011: huffman_out = 3'b011; // Character 3
            4'b0100: huffman_out = 3'b100; // Character 4
            4'b0101: huffman_out = 3'b101; // Character 5
            4'b0110: huffman_out = 3'b110; // Character 6
            4'b0111: huffman_out = 3'b111; // Character 7
            default: huffman_out = 3'bxxx;  // Characters 8-15
        endcase
    end
endmodule