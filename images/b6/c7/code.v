module top_module(
	A,
	B,
	C,
	D,
	S0,
	S1,
	Y
);input A;
   input B;
   input C;
   input D;
   input S0;
   input S1;
   output Y;
   
   wire notS0;
   wire notS1;
   wire w1;
   wire w2;
   
   assign notS0 = ~S0;
   assign notS1 = ~S1;
   assign w1 = A & notS0 & notS1;
   assign w2 = B & notS0 & S1;
   
   assign Y = w1 | w2 | C & S0 & notS1 | D & S0 & S1;
endmodule