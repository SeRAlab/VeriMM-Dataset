module full_adder_1bit(A, B, Cin, Sum, Cout);
input A, B, Cin;
output reg Sum, Cout;

always @(*) begin
    Sum = A ^ B ^ Cin;
    Cout = (A & B) | (B & Cin) | (A & Cin);
end

endmodule