module full_adder(A, B, Cin, Sum, Cout);
input A, B, Cin;
output Sum, Cout;
reg Sum, Cout;

always @(A or B or Cin) begin
    Sum = A ^ B ^ Cin;
    Cout = (A & B) | (A & Cin) | (B & Cin);
end

endmodule