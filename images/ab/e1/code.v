module top_module(in, enable, out);input [4:0] in;
	 input enable;
	 output [4:0] out;
	 
	 
	 
	 wire [4:0] out_ifen;
	 
	 
	 not g1(out_ifen[0], in[0]);
	 
	 
	 xor g2(out_ifen[1], in[0], in[1]);
	 
	 
	 wire w1;
	 and g3(w1, in[0], in[1]);
	 xor g4(out_ifen[2], w1, in[2]);
	 
	 
	 wire w2;
	 and g5(w2, w1, in[2]);
	 xor g6(out_ifen[3], w2, in[3]);
	 
	 
	 wire w3;
	 and g7(w3, w2, in[3]);
	 xor g8(out_ifen[4], w3, in[4]);
	 
	 
	 
	 assign out = (enable) ? out_ifen : in;

endmodule