module rs_encoder (
    input [31:0] data, // 4 data bytes
    output [15:0] encoded // 2 parity bytes
);
    wire [7:0] d0, d1, d2, d3;
    assign d0 = data[7:0];
    assign d1 = data[15:8];
    assign d2 = data[23:16];
    assign d3 = data[31:24];

    // Simple parity calculation (not actual Reed-Solomon encoding)
    // Just for the sake of example
    assign encoded[7:0] = d0 ^ d1 ^ d2 ^ d3; // Data bytes XOR for one parity
    assign encoded[15:8] = d0 & d1 & d2 & d3; // AND for another parity

endmodule