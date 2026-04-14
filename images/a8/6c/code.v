module top_module(A, B, Cin, Sum, Cout);input A,B, Cin;
output Sum, Cout;

reg Cout;
reg T1, T2, T3;

wire S1;
xor X1(S1, A, B); 

always @( A or B or Cin ) 

begin 
T1 = A & Cin;
T2 = B & Cin;
T3 = A & B;
Cout = (T1| T2) | T3;
end

assign Sum = S1 ^ Cin; 

endmodule