module top_module(opcode, aluop, out);input [4:0] opcode, aluop;
	output out;
	
	wire rtype;
	wire mult;
	assign rtype = !(|opcode);
	assign mult = ~aluop[4] & ~aluop[3] & aluop[2] & aluop[1] & ~aluop[0];
	
	assign out = mult & rtype;endmodule