module multiplier_16bit(A, B, P);
    input [15:0] A;
    input [15:0] B;
    output [31:0] P;

    wire [31:0] partial_products [15:0];
    genvar i, j;

    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_pp
            for (j = 0; j < 16; j = j + 1) begin : gen_bits
                assign partial_products[i][j + i] = A[i] & B[j];
            end
            for (j = 16 + i; j < 32; j = j + 1) begin : gen_bits_zero
                assign partial_products[i][j] = 0;
            end
        end
    endgenerate

    assign P = partial_products[0] + partial_products[1] + partial_products[2] + partial_products[3] +
               partial_products[4] + partial_products[5] + partial_products[6] + partial_products[7] +
               partial_products[8] + partial_products[9] + partial_products[10] + partial_products[11] +
               partial_products[12] + partial_products[13] + partial_products[14] + partial_products[15];
endmodule