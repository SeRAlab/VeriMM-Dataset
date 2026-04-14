module top_module(in,out);input [31:0] in;
output [31:0] out;

wire [31:0] man;
wire [8:0] exp;
wire sign;
wire [31:0] res_tmp;

assign man 	= {1'b1, in[22:0],8'd0};
assign exp 	= in[30:23];
assign sign = in[31]; 

assign res_tmp = man >> (8'd127 - exp + 2);

assign out = sign ?	~res_tmp+1 :
					res_tmp;

endmodule