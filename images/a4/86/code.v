module top_module(
    input [7:0] A,
    input [7:0] B,
    input carry_in,
    input X,
    input clk,             // Added clk input
    output reg [7:0] sum,
    output reg carry_out
);reg [7:0] A_reg, B_reg;
reg carry_in_reg;

always @(*) begin
    A_reg = A;
    B_reg = B ^ X; // XOR B with X
    carry_in_reg = carry_in;
end

always @(posedge clk) begin
    {carry_out, sum} <= A_reg + B_reg + carry_in_reg; // Use concatenation for carry_out and sum
end

endmodule