module huffman_encoder (
    input [3:0] char_in,
    output reg [3:0] encoded_out,
    output reg valid
);
    always @(*) begin
        valid = 1;
        case (char_in)
            4'b0000: encoded_out = 4'b0001; // 'A' -> '01'
            4'b0001: encoded_out = 4'b0100; // 'B' -> '100'
            4'b0010: encoded_out = 4'b0101; // 'C' -> '101'
            4'b0011: encoded_out = 4'b1100; // 'D' -> '1100'
            4'b0100: encoded_out = 4'b1101; // 'E' -> '1101'
            4'b0101: encoded_out = 4'b1110; // 'F' -> '1110'
            4'b0110: encoded_out = 4'b1111; // 'G' -> '1111'
            default: begin
                encoded_out = 4'b0000; // Invalid input results in output '0'
                valid = 0;
            end
        endcase
    end
endmodule