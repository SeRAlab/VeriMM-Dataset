module top_module(A, B, C, D, Y2, Y1, Y0);input A, B, C, D;
	output Y2, Y1, Y0;
	
	wire Ai, Bi, Ci, Di;
	wire w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15;
	
	not NotA(Ai, A);
	not NotB(Bi, B);
	not NotC(Ci, C);
	not NotD(Di, D);
	
	// Gates for Y2
	and U1(Y2, A, B, C, D);

	// Gates for Y1
	and U2(w2, Ai, B, D);
	and U3(w3, A, B, Ci);
	and U4(w4, A, Bi, D);
	and U5(w5, A, Bi, C);
	and U6(w6, Ai, C, D);
	and U7(w7, B, C, Di);
	
	// Gates for Y0
	and U8(w8, Ai, Bi, Ci, D);
	and U9(w9, Ai, Bi, C, Di);
	and U10(w10, Ai, B, Ci, Di);
	and U11(w11, A, Bi, Ci, Di);
	and U12(w12, Ai, B, C, D);
	and U13(w13, A, Bi, C, D);
	and U14(w14, A, B, Ci, D);
	and U15(w15, A, B, C, Di);

	or U16(Y1, w2, w3, w4, w5, w6, w7);
	or U17(Y0, w8, w9, w10, w11, w12, w13, w14, w15);
endmodule