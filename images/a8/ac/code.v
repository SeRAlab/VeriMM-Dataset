module top_module(out,carry_out,overflow,A,B,C_in);output [3:0]out;
   output      carry_out,overflow;
   input [3:0] A,B;
   input       C_in;
   wire  [3:0] p,g;
   wire [9:0] andl1;
   wire [2:0] carry ;
   
   xor xx1(p[0],A[0],B[0]);
   xor xx2(p[1],A[1],B[1]);
   xor xx3(p[2],A[2],B[2]);
   xor xx4(p[3],A[3],B[3]);
   
   and aa1(g[0],A[0],B[0]);
   and aa2(g[1],A[1],B[1]);
   and aa3(g[2],A[2],B[2]);
   and aa4(g[3],A[3],B[3]);

   and al1(andl1[0],p[0],C_in);
   and al2(andl1[1],p[1],g[0]);
   and al3(andl1[2],p[1],p[0],C_in);
   and al4(andl1[3],p[2],g[1]);
   and al5(andl1[4],p[2],p[1],g[0]);
   and al6(andl1[5],p[2],p[1],p[0],C_in);
   and al7(andl1[6],p[3],g[2]);
   and al8(andl1[7],p[3],p[2],g[1]);
   and al9(andl1[8],p[3],p[2],p[1],g[0]);
   and al10(andl1[9],p[3],p[2],p[1],p[0],C_in);

   or oo1(carry[0],g[0],andl1[0]);
   or oo2(carry[1],g[1],andl1[1],andl1[2]);
   or oo3(carry[2],g[2],andl1[3],andl1[4],andl1[5]);
   or oo4(carry_out,g[3],andl1[6],andl1[7],andl1[8],andl1[9]);

   xor xs1(out[0],p[0],C_in);
   xor xs2(out[1],p[1],carry[0]);
   xor xs3(out[2],p[2],carry[1]);
   xor xs4(out[3],p[3],carry[2]);
   assign overflow=carry_out^carry[2];
   
endmodule