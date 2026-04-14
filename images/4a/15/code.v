module top_module(A, B, Cin, Sum, Cout);input [7:0] A, B;
   input Cin;
   output [7:0] Sum;
   output Cout;
   
   wire [7:0] Sum_temp;
   
   assign Sum_temp = A + B + Cin;
   
   assign Sum = Sum_temp[7:0];
   assign Cout = Sum_temp[8];
   
endmodule