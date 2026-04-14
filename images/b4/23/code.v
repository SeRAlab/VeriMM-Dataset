module top_module(o, i , s);input [1:0]i;
	input s;
	output o;
	
	assign o = ~s&i[0] | s&i[1];

endmodule