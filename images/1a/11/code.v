module hamming_encoder(
    input [15:0] data_in,
    output [19:0] code_out
);
    wire [3:0] p; // parity bits
    wire [15:0] d; // data bits

    assign d = data_in;

    // Parity bit calculations
    assign p[0] = d[0] ^ d[1] ^ d[3] ^ d[4] ^ d[6] ^ d[8] ^ d[10] ^ d[12] ^ d[14];
    assign p[1] = d[0] ^ d[1] ^ d[2] ^ d[3] ^ d[4] ^ d[5] ^ d[6] ^ d[7] ^ d[8];
    assign p[2] = d[0] ^ d[1] ^ d[2] ^ d[8] ^ d[9] ^ d[10] ^ d[11] ^ d[12] ^ d[13] ^ d[14];
    assign p[3] = d[0] ^ d[2] ^ d[4] ^ d[5] ^ d[6] ^ d[8] ^ d[10] ^ d[11] ^ d[12] ^ d[14];

    // Code output: interleave data and parity bits
    assign code_out[19] = p[3];
    assign code_out[18] = p[2];
    assign code_out[17] = d[15];
    assign code_out[16] = p[1];
    assign code_out[15:12] = d[11:8];
    assign code_out[11:8] = d[7:4];
    assign code_out[7:4] = d[3:0];
    assign code_out[3:0] = p[0];

endmodule