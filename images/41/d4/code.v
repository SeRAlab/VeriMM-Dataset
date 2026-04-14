module top_module(Sum, Cout, A, B, Sin, Cin);input A;
   input B;
   input Sin;
   input Cin;   

   output Sum;
   output Cout;

	wire  w0;
	wire	w1;
	wire	w2;
	wire	w3;
	wire	w4;

	nand    n0(w0, A, B);

	xor	x1(w1, w0, Sin);
	xor	x2(Sum, w1, Cin);

	nand    n1(w2, w0, Sin);
	nand    n2(w3, w0, Cin);
	nand	n3(w4, Sin, Cin);
	
	assign Cout = ~ (w2 & w3 & w4);


endmodule