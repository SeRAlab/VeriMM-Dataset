module top_module(
    input wire [15:0] in,
    output wire [15:0] out,
    output wire parity
);wire [7:0] shifted;
    wire [15:0] swapped;

    assign swapped = {in[7:0], in[15:8]};
    assign shifted = swapped >> 8;
    assign parity = shifted[0] ^ shifted[1] ^ shifted[2] ^ shifted[3] ^ shifted[4] ^ shifted[5] ^ shifted[6] ^ shifted[7];
    assign out = {swapped[7:0], swapped[15:8]};

endmodule