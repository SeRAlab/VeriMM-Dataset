module huffman_encoder (
    input [2:0] char,
    output reg [6:0] huffman_code,
    output reg [2:0] length
);
    always @(*) begin
        case (char)
            3'b000: begin huffman_code = 7'b0000000; length = 1; end // '0' -> '0'
            3'b001: begin huffman_code = 7'b0001010; length = 2; end // '1' -> '10'
            3'b010: begin huffman_code = 7'b0011010; length = 3; end // '2' -> '110'
            3'b011: begin huffman_code = 7'b0111010; length = 4; end // '3' -> '1110'
            3'b100: begin huffman_code = 7'b1111010; length = 5; end // '4' -> '11110'
            3'b101: begin huffman_code = 7'b1111100; length = 6; end // '5' -> '111110'
            3'b110: begin huffman_code = 7'b1111110; length = 7; end // '6' -> '1111110'
            3'b111: begin huffman_code = 7'b1111111; length = 8; end // '7' -> '1111111'
            default: begin huffman_code = 7'b0000000; length = 0; end // default case
        endcase
    end
endmodule