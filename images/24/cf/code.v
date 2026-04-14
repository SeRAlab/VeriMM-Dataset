module huffman_encoder (
    input [1:0] symbol,
    output reg [2:0] huffman_code
);

always @(*) begin
    case (symbol)
        2'b00: huffman_code = 3'b00; // Symbol A
        2'b01: huffman_code = 3'b01; // Symbol B
        2'b10: huffman_code = 3'b10; // Symbol C
        default: huffman_code = 3'bxx; // Undefined
    endcase
end

endmodule