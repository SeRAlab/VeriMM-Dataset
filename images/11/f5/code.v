module huffman_encoder (
    input [7:0] char_in,
    output reg [1:0] huffman_code
);

always @(*) begin
    case (char_in)
        8'h41: huffman_code = 2'b00; // 'A'
        8'h42: huffman_code = 2'b01; // 'B'
        8'h43: huffman_code = 2'b10; // 'C'
        8'h44: huffman_code = 2'b11; // 'D'
        default: huffman_code = 2'bxx; // default case
    endcase
end

endmodule