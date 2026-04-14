module top_module(X1, X2, X3, X4, X5, X6, X7, f);input X1, X2, X3, X4, X5, X6, X7;
	output reg f;
	
	always @(X1, X2, X3, X4, X5, X6, X7)
		if ((~X1 & ~X2) | (~X1 & ~X3) | (~X1 & ~X4) | (~X1 & ~X5) | (~X1 & ~X6) | (~X1 & ~X7) | (~X2 & ~X3) | (~X2 & ~X4) | (~X2 & ~X5) | (~X2 & ~X6) | (~X2 & ~X7) | (~X3 & ~X4) | (~X3 & ~X5) | (~X3 & ~X6) | (~X3 & ~X7) | (~X4 & ~X5) | (~X4 & ~X6) | (~X4 & ~X7) | (~X5 & ~X6) | (~X5 & ~X7) | (~X6 & ~X7))
			f = 1;
		else
			f = 0;
endmodule