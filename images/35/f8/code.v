module huffman_encoder(
    input [7:0] char_in, // Input character (ASCII)
    output reg [15:0] huffman_code // Output Huffman code
);

always @(*) begin
    case (char_in)
        8'h41: huffman_code = 16'b110;    // A -> 110
        8'h42: huffman_code = 16'b1110;   // B -> 1110
        8'h43: huffman_code = 16'b1111;   // C -> 1111
        8'h44: huffman_code = 16'b10;     // D -> 10
        default: huffman_code = 16'b0;    // Unknown character
    endcase
end

endmodule