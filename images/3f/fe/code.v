module huffman_encoder (
    input [3:0] symbol,
    output reg [2:0] huffman_code
);
    always @(*) begin
        case (symbol)
            4'b0000: huffman_code = 3'b000; // Symbol 0
            4'b0001: huffman_code = 3'b001; // Symbol 1
            4'b0010: huffman_code = 3'b010; // Symbol 2
            4'b0011: huffman_code = 3'b011; // Symbol 3
            4'b0100: huffman_code = 3'b100; // Symbol 4
            4'b0101: huffman_code = 3'b101; // Symbol 5
            4'b0110: huffman_code = 3'b110; // Symbol 6
            4'b0111: huffman_code = 3'b111; // Symbol 7
            default: huffman_code = 3'b111;  // Invalid symbol
        endcase
    end
endmodule