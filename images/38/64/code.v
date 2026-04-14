module hamming_encoder (
    input [3:0] D,
    output [6:0] C
);
    assign C[0] = D[0] ^ D[1] ^ D[3]; // parity bit P1
    assign C[1] = D[0] ^ D[2] ^ D[3]; // parity bit P2
    assign C[2] = D[1] ^ D[2] ^ D[3]; // parity bit P3
    assign C[3] = D[0]; // data bit D0
    assign C[4] = D[1]; // data bit D1
    assign C[5] = D[2]; // data bit D2
    assign C[6] = D[3]; // data bit D3
endmodule