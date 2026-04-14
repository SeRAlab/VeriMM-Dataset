module top_module(Sum, Cout, A, B, Cin);input A;
   input B;
   input Cin;   

   output Sum;
   output Cout;

   wire w1, w2, w3, w4, w5, w6;

   xor x1(w1, A, B);
   xor x2(Sum, w1, Cin);

   nand n1(w2, A, B);
   nand n2(w3, A, Cin);
   nand n3(w4, B, Cin);
   nand n4(w5, w2, w3);
   nand n5(w6, w4, w1);
   nand n6(Cout, w5, w6);

endmodule