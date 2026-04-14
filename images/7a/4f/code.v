module top_module(
    input clk,         // Add clock input
    input [3:0] A,
    input [3:0] B,
    input Cn,
    output reg [3:0] S,
    output reg V
);reg [3:0] A_reg, B_reg, S_reg;
reg Cn_reg;

always @(posedge clk) begin
    A_reg <= A;
    B_reg <= B;
    Cn_reg <= Cn;
end

always @(posedge clk) begin
    S_reg <= A_reg + (B_reg ^ 4'b1111) + Cn_reg;
end

always @(posedge clk) begin
    S <= S_reg;
    V <= (S[3] ^ A_reg[3]) & (S[3] ^ B_reg[3]);
end

endmodule