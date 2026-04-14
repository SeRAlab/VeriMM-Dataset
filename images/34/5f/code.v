module huffman_encoder (
    input [3:0] data_in,
    output reg [1:0] huffman_code
);

always @(*) begin
    case (data_in)
        4'b0000: huffman_code = 2'b00;
        4'b0001: huffman_code = 2'b01;
        4'b0010: huffman_code = 2'b10;
        4'b0011: huffman_code = 2'b11;
        default:  huffman_code = 2'b00;
    endcase
end

endmodule