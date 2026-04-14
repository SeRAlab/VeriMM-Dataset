module top_module(
	A, 
	B, 
	C,
	Y
);input A;
   input B;
   input C;
   output Y;
   wire X1;
   wire X2;
   wire X3;
   wire X4;
   wire X5;
   wire X6;
   wire X7;
   wire X8;
   wire X9;
   wire X10;
   wire X11;
   wire X12;
   wire X13;
   wire X14;
   wire X15;
   wire X16;

   assign X1 = ~A & ~B;
   assign X2 = C;
   assign X3 = X1 & X2;
   assign X4 = ~A;
   assign X5 = ~B;
   assign X6 = X4 & X5;
   assign X7 = C;
   assign X8 = X6 & X7;
   assign X9 = ~A;
   assign X10 = B;
   assign X11 = X9 & X10;
   assign X12 = C;
   assign X13 = X11 & X12;
   assign X14 = A;
   assign X15 = ~B;
   assign X16 = X14 & X15 & C;
   
   assign Y = X3 | X8 | X13 | X16;
endmodule