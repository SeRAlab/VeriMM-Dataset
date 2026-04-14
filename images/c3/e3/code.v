module ripple_carry_adder (
    input [7:0] A,
    input [7:0] B,
    input carry_in,
    input X,
    output reg [7:0] sum,
    output reg carry_out
);

reg [7:0] A_reg, B_reg, sum_reg;
reg carry_in_reg, carry_out_reg;

always @(*) begin
    A_reg = A;
    B_reg = B ^ X; // XOR B with X
    carry_in_reg = carry_in;
end

always @(posedge clk) begin
    sum_reg = A_reg + B_reg + carry_in_reg;
    carry_out_reg = (A_reg[7] & B_reg[7]) | (B_reg[7] & carry_in_reg) | (A_reg[7] & carry_in_reg);
end

always @(posedge clk) begin
    sum <= sum_reg;
    carry_out <= carry_out_reg;
end

endmodule