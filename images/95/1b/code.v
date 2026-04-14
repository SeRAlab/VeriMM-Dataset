module top_module(Q,Qbar,S,R);input S,R;
	output Q,Qbar;
	
	assign Q = ~(R&Qbar);
	assign Qbar = ~(S&Q);
endmodule