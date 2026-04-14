module huffman_encoder(
    input [2:0] char_input,
    output reg [4:0] huffman_output
);
    always @(*) begin
        case (char_input)
            3'b000: huffman_output = 5'b00000; // A -> 0
            3'b001: huffman_output = 5'b00010; // B -> 10
            3'b010: huffman_output = 5'b00110; // C -> 110
            3'b011: huffman_output = 5'b01110; // D -> 1110
            3'b100: huffman_output = 5'b01111; // E -> 1111
            3'b111: huffman_output = 5'b11111; // H -> 11111
            default: huffman_output = 5'bxxxxx; // For invalid input
        endcase
    end
endmodule