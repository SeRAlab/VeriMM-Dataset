module top_module(
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input clk,            // Added the input clk signal
    output reg [3:0] s,
    output reg [3:0] c_out
);reg [3:0] p1, g1, p2, g2, p3, g3;

always @(*) begin
    p1 = a ^ b;
    g1 = a & b;
    p2 = p1 ^ c;
    g2 = p1 & c;
    p3 = p2 ^ g1;
    g3 = p2 & g1;
end

always @(posedge clk) begin
    s <= p3;
    c_out <= g3;
end

endmodule