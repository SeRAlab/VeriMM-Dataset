module huffman_encoder (
    input [3:0] char_in,
    output reg [7:0] encoded_out
);
    always @* begin
        case (char_in)
            4'b0000: encoded_out = 8'b110;   // A
            4'b0001: encoded_out = 8'b1110;  // B
            4'b0010: encoded_out = 8'b1111;  // C
            4'b0011: encoded_out = 8'b10;    // D
            4'b0100: encoded_out = 8'b00;     // E
            // Other character mappings...
            default: encoded_out = 8'b00000000; // Default case
        endcase
    end
endmodule