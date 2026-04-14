module full_adder_1bit(A, B, Cin, Sum, Cout);
    input A;
    input B;
    input Cin;
    output Sum;
    output Cout;

    assign Sum = A ^ B ^ Cin;
    assign Cout = (A & B) | (B & Cin) | (A & Cin);
endmodule