module multiplier_64x64 (
    input [63:0] A,
    input [63:0] B,
    output [127:0] P
);
    wire [127:0] partial [0:63];
    assign P = partial[0] + partial[1] + partial[2] + partial[3] + 
               partial[4] + partial[5] + partial[6] + partial[7] +
               partial[8] + partial[9] + partial[10] + partial[11] +
               partial[12] + partial[13] + partial[14] + partial[15] +
               partial[16] + partial[17] + partial[18] + partial[19] +
               partial[20] + partial[21] + partial[22] + partial[23] +
               partial[24] + partial[25] + partial[26] + partial[27] +
               partial[28] + partial[29] + partial[30] + partial[31] +
               partial[32] + partial[33] + partial[34] + partial[35] +
               partial[36] + partial[37] + partial[38] + partial[39] +
               partial[40] + partial[41] + partial[42] + partial[43] +
               partial[44] + partial[45] + partial[46] + partial[47] +
               partial[48] + partial[49] + partial[50] + partial[51] +
               partial[52] + partial[53] + partial[54] + partial[55] +
               partial[56] + partial[57] + partial[58] + partial[59] +
               partial[60] + partial[61] + partial[62] + partial[63];

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : gen_partial_products
            assign partial[i] = (A & {64{B[i]}}) << i;
        end
    endgenerate
endmodule