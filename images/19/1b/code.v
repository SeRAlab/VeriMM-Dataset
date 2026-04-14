module huffman_encoder (
    input [3:0] char_in,
    output reg [2:0] code_out
);

always @(*) begin
    case (char_in)
        4'b0000: code_out = 3'b000; // A
        4'b0001: code_out = 3'b001; // B
        4'b0010: code_out = 3'b010; // C
        4'b0011: code_out = 3'b011; // D
        4'b0100: code_out = 3'b100; // E
        4'b0101: code_out = 3'b101; // F
        4'b0110: code_out = 3'b110; // G
        4'b0111: code_out = 3'b111; // H
        default: code_out = 3'bxxx; // Invalid input
    endcase
end

endmodule