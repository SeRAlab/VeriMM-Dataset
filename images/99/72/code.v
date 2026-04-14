module top_module(in, sel, out);input sel;
	input [1:0]in;
	output out;
	wire w1, w2, w3, w4;

	not not1(w1, sel);   
	and and1(w2, in[1], sel);  
	and and2(w3, in[0], w1);  
	or or1(w4, w2, w3);   
	assign out = w4;

endmodule