module ripple_carry_adder(
    input [3:0] A,
    input [3:0] B,
    input Clk,
    output [3:0] S,
    output Cout
);

reg [3:0] S_reg;
reg Cout_reg;

always @(posedge Clk) begin
    // add the two inputs and the carry-in
    S_reg = A + B + Cout_reg;
    // determine the carry-out
    Cout_reg = (A[3] & B[3]) | (A[3] & Cout_reg) | (B[3] & Cout_reg);
end

assign S = S_reg;
assign Cout = Cout_reg;

endmodule