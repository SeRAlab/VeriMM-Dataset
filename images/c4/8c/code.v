module four_bit_adder (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    input Clk,
    output [3:0] Sum,
    output Cout
);

    reg [3:0] Sum_reg;
    reg Cout_reg;

    always @(posedge Clk) begin
        {Cout_reg, Sum_reg} <= A + B + Cin;
    end

    assign Sum = Sum_reg;
    assign Cout = Cout_reg;

endmodule