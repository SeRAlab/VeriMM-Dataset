module top_module(J, K, CLK, Q, Q_B);input	J, K, CLK;
output	Q, Q_B;
reg		Q;

	assign	Q_B = ~Q;
	always 	@	(posedge CLK)
	case ({J,K})
		1:	Q <= 0;
		2:	Q <= 1;
		3:  Q <= ~Q;
	endcase
endmodule