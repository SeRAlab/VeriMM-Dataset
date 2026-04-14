module top_module(
    input [7:0] a,
    input [7:0] b,
    input mul,
    output [15:0] result
);wire [7:0] p0, p1, p2, p3, p4, p5, p6, p7;
wire [7:0] g0, g1, g2, g3, g4, g5, g6, g7;
wire [7:0] c0, c1, c2, c3, c4, c5, c6, c7, c8;

assign p0 = a & {b[0], b[0], b[0], b[0], b[0], b[0], b[0], b[0]};
assign p1 = a & {b[1], b[1], b[1], b[1], b[1], b[1], b[1], b[1]};
assign p2 = a & {b[2], b[2], b[2], b[2], b[2], b[2], b[2], b[2]};
assign p3 = a & {b[3], b[3], b[3], b[3], b[3], b[3], b[3], b[3]};
assign p4 = a & {b[4], b[4], b[4], b[4], b[4], b[4], b[4], b[4]};
assign p5 = a & {b[5], b[5], b[5], b[5], b[5], b[5], b[5], b[5]};
assign p6 = a & {b[6], b[6], b[6], b[6], b[6], b[6], b[6], b[6]};
assign p7 = a & {b[7], b[7], b[7], b[7], b[7], b[7], b[7], b[7]};

assign g0 = p0;
assign g1 = p1 ^ c0;
assign g2 = p2 ^ c1;
assign g3 = p3 ^ c2;
assign g4 = p4 ^ c3;
assign g5 = p5 ^ c4;
assign g6 = p6 ^ c5;
assign g7 = p7 ^ c6;

assign c0 = g0;
assign c1 = g1 & g0;
assign c2 = g2 & g1 & g0;
assign c3 = g3 & g2 & g1 & g0;
assign c4 = g4 & g3 & g2 & g1 & g0;
assign c5 = g5 & g4 & g3 & g2 & g1 & g0;
assign c6 = g6 & g5 & g4 & g3 & g2 & g1 & g0;
assign c7 = g7 & g6 & g5 & g4 & g3 & g2 & g1 & g0;
assign c8 = g7 & g6 & g5 & g4 & g3 & g2 & g1;

wire [15:0] sum;
assign sum = {c8, c7, c6, c5, c4, c3, c2, c1, c0, g7, g6, g5, g4, g3, g2, g1};

assign result = mul ? sum : 16'b0;

endmodule