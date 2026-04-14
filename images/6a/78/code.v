module top_module(out , A ,B);// I/O port declaration
output [31:0] out;
input [31:0] A,B;

wire [31:0] inter;

// OR gates for each bit
or c0(inter[0],A[0],B[0]);
or c1(inter[1],A[1],B[1]);
or c2(inter[2],A[2],B[2]);
or c3(inter[3],A[3],B[3]);
or c4(inter[4],A[4],B[4]);
or c5(inter[5],A[5],B[5]);
or c6(inter[6],A[6],B[6]);
or c7(inter[7],A[7],B[7]);
or c8(inter[8],A[8],B[8]);
or c9(inter[9],A[9],B[9]);
or c10(inter[10],A[10],B[10]);
or c11(inter[11],A[11],B[11]);
or c12(inter[12],A[12],B[12]);
or c13(inter[13],A[13],B[13]);
or c14(inter[14],A[14],B[14]);
or c15(inter[15],A[15],B[15]);
or c16(inter[16],A[16],B[16]);
or c17(inter[17],A[17],B[17]);
or c18(inter[18],A[18],B[18]);
or c19(inter[19],A[19],B[19]);
or c20(inter[20],A[20],B[20]);
or c21(inter[21],A[21],B[21]);
or c22(inter[22],A[22],B[22]);
or c23(inter[23],A[23],B[23]);
or c24(inter[24],A[24],B[24]);
or c25(inter[25],A[25],B[25]);
or c26(inter[26],A[26],B[26]);
or c27(inter[27],A[27],B[27]);
or c28(inter[28],A[28],B[28]);
or c29(inter[29],A[29],B[29]);
or c30(inter[30],A[30],B[30]);
or c31(inter[31],A[31],B[31]);

assign out = inter;

endmodule