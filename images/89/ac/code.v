module top_module(
    input [10:0] d,
    output [14:0] c
);// Calculate parity bits
    wire p0 = d[0] ^ d[1] ^ d[3] ^ d[4] ^ d[6] ^ d[8] ^ d[10];
    wire p1 = d[0] ^ d[2] ^ d[3] ^ d[5] ^ d[6] ^ d[9] ^ d[10];
    wire p2 = d[1] ^ d[2] ^ d[3] ^ d[7] ^ d[8] ^ d[9] ^ d[10];
    wire p3 = d[4] ^ d[5] ^ d[6] ^ d[7] ^ d[8] ^ d[9] ^ d[10];

    // Assign output bits
    assign c[0] = p0;
    assign c[1] = p1;
    assign c[2] = d[0];
    assign c[3] = p2;
    assign c[4] = d[1];
    assign c[5] = d[2];
    assign c[6] = d[3];
    assign c[7] = p3;
    assign c[8] = d[4];
    assign c[9] = d[5];
    assign c[10] = d[6];
    assign c[11] = d[7];
    assign c[12] = d[8];
    assign c[13] = d[9];
    assign c[14] = d[10];
    
endmodule