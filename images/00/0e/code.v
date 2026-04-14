module hamming_encoder (
    input [3:0] data_in,
    output [6:0] codeword
);
    wire p1, p2, p3;

    assign p1 = data_in[0] ^ data_in[1] ^ data_in[3]; // parity bit 1
    assign p2 = data_in[0] ^ data_in[2] ^ data_in[3]; // parity bit 2
    assign p3 = data_in[1] ^ data_in[2] ^ data_in[3]; // parity bit 3

    assign codeword[6] = p1;         // p1
    assign codeword[5] = p2;         // p2
    assign codeword[4] = data_in[0]; // d1
    assign codeword[3] = p3;         // p3
    assign codeword[2] = data_in[1]; // d2
    assign codeword[1] = data_in[2]; // d3
    assign codeword[0] = data_in[3]; // d4
endmodule