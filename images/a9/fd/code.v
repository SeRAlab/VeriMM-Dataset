module top_module(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    input clk,  // Added clk input
    output reg [3:0] Sum,
    output reg Cout
);reg [3:0] A_reg, B_reg, Sum_reg;
reg Cin_reg, Cout_reg;

// Pipeline stage 1
always @(*) begin
    A_reg = A;
    B_reg = B;
    Cin_reg = Cin;
end

// Pipeline stage 2
always @(posedge clk) begin
    // Full adder for bit 0
    {Sum_reg[0], Cout_reg} = A_reg[0] + B_reg[0] + Cin_reg;
    
    // Full adder for bit 1
    {Sum_reg[1], Cout_reg} = A_reg[1] + B_reg[1] + Cout_reg;
    
    // Full adder for bit 2
    {Sum_reg[2], Cout_reg} = A_reg[2] + B_reg[2] + Cout_reg;
    
    // Full adder for bit 3
    {Sum_reg[3], Cout} = A_reg[3] + B_reg[3] + Cout_reg;
end

// Pipeline stage 3
always @(posedge clk) begin
    Sum <= Sum_reg;
    Cout <= Cout_reg;
end

endmodule