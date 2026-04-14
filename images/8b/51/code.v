module rca_4bit(A, B, Cin, S, Cout);
     input [3:0] A;
     input [3:0] B;
     input Cin;
     output [3:0] S;
     output Cout;

     wire C1, C2, C3;

     full_adder FA0 (
         .A(A[0]),
         .B(B[0]),
         .Cin(Cin),
         .S(S[0]),
         .Cout(C1)
     );

     full_adder FA1 (
         .A(A[1]),
         .B(B[1]),
         .Cin(C1),
         .S(S[1]),
         .Cout(C2)
     );

     full_adder FA2 (
         .A(A[2]),
         .B(B[2]),
         .Cin(C2),
         .S(S[2]),
         .Cout(C3)
     );

     full_adder FA3 (
         .A(A[3]),
         .B(B[3]),
         .Cin(C3),
         .S(S[3]),
         .Cout(Cout)
     );
endmodule

module full_adder(A, B, Cin, S, Cout);
     input A, B, Cin;
     output S, Cout;

     assign S = A ^ B ^ Cin;
     assign Cout = (A & B) | (B & Cin) | (Cin & A);
endmodule