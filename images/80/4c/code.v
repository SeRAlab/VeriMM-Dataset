module top_module(vec,outv,o0,o1,o2);input wire [2:0] vec;
	output wire [2:0] outv;
	output wire o0,o1,o2;

	assign outv = vec;
	assign o0 = vec[0];
	assign o1 = vec[1];
	assign o2 = vec[2];
endmodule