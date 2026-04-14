module top_module(A, B, Cin, Sum, Cout);input A;
    input B;
    input Cin;
    output Sum;
    output Cout;

    assign Sum = A ^ B ^ Cin; // Sum is the XOR of A, B, and Cin
    assign Cout = (A & B) | (Cin & (A ^ B)); // Carry-out is determined by the majority function of A, B, and Cin
endmodule