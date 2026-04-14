module top_module(A, B, Cin, Clk, Sum, Cout);input [3:0] A;
input [3:0] B;
input Cin;
input Clk;
output [3:0] Sum;
output Cout;

reg [3:0] Sum_reg;
reg Cout_reg;

always @(posedge Clk) begin
    Sum_reg <= A + B + Cin;
    Cout_reg <= (A[3] & B[3]) | (A[3] & Cin) | (B[3] & Cin);
end

assign Sum = Sum_reg;
assign Cout = Cout_reg;

endmodule