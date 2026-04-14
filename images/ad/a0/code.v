module top_module(
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    output [3:0] sum,
    output cout
);reg [3:0] p1, p2, p3, g1, g2, g3;
reg [4:0] c1, c2, c3;

assign sum = p3;
assign cout = c3[4];

always @(*) begin
    p1 = a ^ b;
    g1 = a & b;
    c1 = {1'b0, g1} + c;

    p2 = p1 ^ c1[3:0];
    g2 = p1 & c1[3:0];
    c2 = {1'b0, g2} + c1[4];

    p3 = p2 ^ c2[3:0];
    g3 = p2 & c2[3:0];
    c3 = {1'b0, g3} + c2[4];
end

endmodule