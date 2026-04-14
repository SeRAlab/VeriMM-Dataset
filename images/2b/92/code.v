module brent_kung_adder (
    input [3:0] a,        // 4-bit input A
    input [3:0] b,        // 4-bit input B
    output [4:0] sum      // 5-bit output sum (including carry out)
);

wire [3:0] p; // propagate
wire [3:0] g; // generate
wire [3:0] c; // carry

// Generate and propagate
assign p = a ^ b; // propagate
assign g = a & b; // generate

// Carry calculation
assign c[0] = 0; // No carry in
assign c[1] = g[0] | (p[0] & c[0]);
assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);

// Sum calculation
assign sum[0] = p[0] ^ c[0];
assign sum[1] = p[1] ^ c[1];
assign sum[2] = p[2] ^ c[2];
assign sum[3] = p[3] ^ c[3];
assign sum[4] = g[3] | (p[3] & c[3]); // carry out

endmodule