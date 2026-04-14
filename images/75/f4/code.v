module top_module(output reg Q, input C, E, R, D);reg Q_next;
	always @*
		if (R)
			Q_next = 0;
		else if (E)
			Q_next = D;
		else
			Q_next = Q;

	always @(posedge C)
		Q <= Q_next;

endmodule