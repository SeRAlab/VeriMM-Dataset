module top_module(in0,in1,sel,m_out);input[7:0] in0,in1;
	input sel;
	output [7:0] m_out;

	assign m_out = (in0&~sel) | (in1&sel);endmodule