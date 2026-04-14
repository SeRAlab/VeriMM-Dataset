module top_module(
    input [3:0] D,
    output A,
    output B,
    output C,
    output D_out, // Renamed output D to D_out
    output E,
    output F,
    output G
);assign A = ~D[3] & ~D[2] & ~D[1] & D[0];
    assign B = ~D[3] & ~D[2] & D[1] & ~D[0];
    assign C = ~D[3] & D[2] & ~D[1] & ~D[0];
    assign D_out = ~D[3] & D[2] & ~D[1] & D[0]; // Replaced D with D_out
    assign E = ~D[3] & D[2] & D[1] & ~D[0];
    assign F = D[3] & ~D[2] & ~D[1] & ~D[0];
    assign G = D[3] & ~D[2] & ~D[1] & D[0];

endmodule