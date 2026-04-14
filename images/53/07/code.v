module top_module(
    input [3:0] a,
    input [3:0] b,
    input cin,
    output reg [3:0] sum,
    output reg cout
);wire c0, c1, c2;

    // First bit
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign c0 = (a[0] & b[0]) | (cin & (a[0] ^ b[0]));

    // Second bit
    assign sum[1] = a[1] ^ b[1] ^ (c0);
    assign c1 = (a[1] & b[1]) | (c0 & (a[1] ^ b[1]));

    // Third bit
    assign sum[2] = a[2] ^ b[2] ^ (c1);
    assign c2 = (a[2] & b[2]) | (c1 & (a[2] ^ b[2]));

    // Fourth bit
    assign sum[3] = a[3] ^ b[3] ^ (c2);
    assign cout = (a[3] & b[3]) | (c2 & (a[3] ^ b[3]));

endmodule