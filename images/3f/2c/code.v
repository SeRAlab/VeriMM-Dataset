module hamming_encoder (
    input [3:0] data,
    output [6:0] code
);
    wire p1, p2, p3;

    // Parity calculations
    assign p1 = data[0] ^ data[1] ^ data[3]; // parity bit for positions 1, 2, 4
    assign p2 = data[0] ^ data[2] ^ data[3]; // parity bit for positions 1, 3, 4
    assign p3 = data[1] ^ data[2] ^ data[3]; // parity bit for positions 2, 3, 4

    // Codeword formation
    assign code[6] = data[0]; // d1
    assign code[5] = data[1]; // d2
    assign code[4] = p1;      // p1
    assign code[3] = data[2]; // d3
    assign code[2] = p2;      // p2
    assign code[1] = data[3]; // d4
    assign code[0] = p3;      // p3
endmodule