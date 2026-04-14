module top_module(MO, A, B, S);input A, B, S;
   output MO;
   
   wire A_in;
   wire B_in;
   wire S_in;

   buf(A_in, A);
   buf(B_in, B);
   buf(S_in, S);

   assign MO = (S_in == 1) ? B_in : A_in;
endmodule