module top_module(in,out);input [7:0]in;
output reg[6:0]out;
reg [3:0]a,b;

always @(in) begin
	a=in[3:0];
	b=in[7:4];
	if (a>9||b>9) out = 7'bx;
	else out = 10*b + a;
	end
endmodule