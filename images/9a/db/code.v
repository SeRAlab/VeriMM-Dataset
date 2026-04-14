module top_module(in, ctrl, out);input [11:0] in;
	input ctrl;
	output [11:0] out;
	
	assign out[0] = ctrl ? in[0] : 1'bz;
	assign out[1] = ctrl ? in[1] : 1'bz;
	assign out[2] = ctrl ? in[2] : 1'bz;
	assign out[3] = ctrl ? in[3] : 1'bz;
	assign out[4] = ctrl ? in[4] : 1'bz;
	assign out[5] = ctrl ? in[5] : 1'bz;
	assign out[6] = ctrl ? in[6] : 1'bz;
	assign out[7] = ctrl ? in[7] : 1'bz;
	assign out[8] = ctrl ? in[8] : 1'bz;
	assign out[9] = ctrl ? in[9] : 1'bz;
	assign out[10] = ctrl ? in[10] : 1'bz;
	assign out[11] = ctrl ? in[11] : 1'bz;
	
endmodule