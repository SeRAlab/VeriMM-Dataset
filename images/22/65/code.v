module huffman_encoder (
    input [3:0] char_input,
    output reg [2:0] huffman_code
);

always @(*) begin
    case (char_input)
        4'b0000: huffman_code = 3'b000; // 00
        4'b0001: huffman_code = 3'b001; // 01
        4'b0010: huffman_code = 3'b010; // 10
        4'b0011: huffman_code = 3'b110; // 110
        4'b0100: huffman_code = 3'b111; // 111
        default: huffman_code = 3'b111;  // not found
    endcase
end

endmodule