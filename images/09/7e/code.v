module huffman_encoder (
    input [3:0] symbol, // 4-bit input symbol
    output reg [7:0] huffman_code, // 8-bit output Huffman code
    output reg [3:0] code_length // Length of the output code
);

// Define Huffman codes based on the predefined tree
always @(*) begin
    case (symbol)
        4'b0000: begin huffman_code = 8'b110; code_length = 4; end // Symbol 0
        4'b0001: begin huffman_code = 8'b1110; code_length = 4; end // Symbol 1
        4'b0010: begin huffman_code = 8'b1111; code_length = 4; end // Symbol 2
        4'b0011: begin huffman_code = 8'b10; code_length = 3; end // Symbol 3
        4'b0100: begin huffman_code = 8'b0; code_length = 1; end // Symbol 4
        default: begin huffman_code = 8'b00000000; code_length = 0; end // Default case
    endcase
end

endmodule