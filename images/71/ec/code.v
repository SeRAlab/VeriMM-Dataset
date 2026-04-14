module top_module(
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);wire [3:0] xor_out;
    wire [3:0] and_out;
    wire [3:0] or_out;

    // XOR gates for sum calculation
    xor x1 (xor_out[0], a[0], b[0]);
    xor x2 (xor_out[1], a[1], b[1]);
    xor x3 (xor_out[2], a[2], b[2]);
    xor x4 (xor_out[3], a[3], b[3]);

    // AND gates for carry calculation
    and a1 (and_out[0], a[0], b[0]);
    and a2 (and_out[1], a[1], b[1]);
    and a3 (and_out[2], a[2], b[2]);
    and a4 (and_out[3], a[3], b[3]);

    // OR gates for carry calculation
    or o1 (or_out[0], and_out[0], and_out[1]);
    or o2 (or_out[1], and_out[2], and_out[3]);
    or o3 (or_out[2], xor_out[0], xor_out[1]);
    or o4 (or_out[3], xor_out[2], xor_out[3]);

    // Carry-out calculation
    assign cout = or_out[3];

    // Sum calculation
    assign sum[0] = xor_out[0] ^ cin;
    assign sum[1] = xor_out[1] ^ and_out[0];
    assign sum[2] = xor_out[2] ^ and_out[1];
    assign sum[3] = xor_out[3] ^ and_out[2];

endmodule