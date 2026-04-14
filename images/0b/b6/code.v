module hamming_encoder (
    input [3:0] data,
    output [6:0] codeword
);
    wire p1, p2, p3;

    assign p1 = data[0] ^ data[1] ^ data[3]; // Parity bit for bits 1, 2, and 4
    assign p2 = data[0] ^ data[2] ^ data[3]; // Parity bit for bits 1, 3, and 5
    assign p3 = data[1] ^ data[2] ^ data[3]; // Parity bit for bits 2, 3, and 6

    assign codeword[6] = p3; // Bit 7
    assign codeword[5] = p2; // Bit 6
    assign codeword[4] = data[3]; // Bit 5
    assign codeword[3] = p1; // Bit 4
    assign codeword[2] = data[2]; // Bit 3
    assign codeword[1] = data[1]; // Bit 2
    assign codeword[0] = data[0]; // Bit 1
endmodule