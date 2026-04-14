module binary_to_gray(
    input [3:0] D,
    output [3:0] G
);

    assign G[0] = D[0];
    assign G[1] = D[0] ^ D[1];
    assign G[2] = D[1] ^ D[2];
    assign G[3] = D[2] ^ D[3];

endmodule