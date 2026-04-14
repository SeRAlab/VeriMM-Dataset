module top_module(in1, in2, cin, sum, cout);input wire in1, in2, cin;
	output wire sum, cout;
	assign sum = in1 ^ in2 ^ cin;
	assign cout = (in1 & in2) | (in2 & cin) | (cin & in1);
endmodule