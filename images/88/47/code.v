module top_module(F,A,B,C,D);output F;
 input A,B,C,D;
 assign F = A&&B&&D || (!A)&&C&&(!D);
endmodule