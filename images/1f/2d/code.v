module wallace_multiplier (
    input [7:0] A,
    input [7:0] B,
    output [15:0] P
);
    wire [15:0] partial[7:0]; // Partial products
    wire [15:0] sum[5:0]; // Sums in Wallace tree
    wire [5:0] carry; // Carries for the sums

    // Generate partial products
    genvar i, j;
    generate
        for (i = 0; i < 8; i = i + 1) begin: partial_products
            assign partial[i] = (B[i]) ? (A << i) : 16'b0;
        end
    endgenerate

    // First stage of reduction
    assign {sum[0], carry[0]} = partial[0] + partial[1];
    assign {sum[1], carry[1]} = partial[2] + partial[3];
    assign {sum[2], carry[2]} = partial[4] + partial[5];
    assign {sum[3], carry[3]} = partial[6] + partial[7];
    assign sum[4] = carry[0] + carry[1];
    assign sum[5] = carry[2] + carry[3];

    // Final stage to get product
    assign P = sum[0] + sum[1] + sum[4] + sum[5];
endmodule