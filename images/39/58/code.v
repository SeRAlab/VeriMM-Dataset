module huffman_encoder(
    input [3:0] symbol,
    output reg [11:0] encoded
);
    always @(*) begin
        case (symbol)
            4'b0000: encoded = 12'b000000000000; // Symbol 0: 00
            4'b0001: encoded = 12'b000000000001; // Symbol 1: 01
            4'b0010: encoded = 12'b000000000010; // Symbol 2: 10
            4'b0011: encoded = 12'b000000000011; // Symbol 3: 11
            4'b0100: encoded = 12'b000000000000000000000000; // Symbol 4: 000
            4'b0101: encoded = 12'b000000000000000000000001; // Symbol 5: 001
            4'b0110: encoded = 12'b000000000000000000000010; // Symbol 6: 010
            4'b0111: encoded = 12'b000000000000000000000011; // Symbol 7: 011
            4'b1000: encoded = 12'b000000000000000000000100; // Symbol 8: 100
            4'b1001: encoded = 12'b000000000000000000000101; // Symbol 9: 101
            4'b1010: encoded = 12'b000000000000000000000110; // Symbol 10: 110
            4'b1011: encoded = 12'b000000000000000000000111; // Symbol 11: 111
            default: encoded = 12'b000000000000; // Default case
        endcase
    end
endmodule