module top_module(
		input wire D,CLK,
		output wire Q,nQ);wire X,Y;
		
		assign X = ~(D & CLK);
		assign Y = ~(~D & CLK);
		
		assign Q = ~(X & nQ);
		assign nQ = ~(Y & Q);
endmodule