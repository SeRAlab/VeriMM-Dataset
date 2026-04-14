module top_module(i, o );input [2:0]i;
	output [7:0]o;
	
	assign o[0] = ~i[0]&~i[1]&~i[2];
	assign o[1] = i[0]&~i[1]&~i[2];
	assign o[2] = ~i[0]&i[1]&~i[2];
	assign o[3] = i[0]&i[1]&~i[2];
	assign o[4] = ~i[0]&~i[1]&i[2];
	assign o[5] = i[0]&~i[1]&i[2];
	assign o[6] = ~i[0]&i[1]&i[2];
	assign o[7] = i[0]&i[1]&i[2];
endmodule