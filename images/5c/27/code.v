module top_module(a,b,cin,sum,cout,op);input a;
	input b;
	input op;
	input cin;
	
	output sum;
	wire sum;
	output cout;
	wire cout;
	wire temp;
	
	assign temp = b^op;
	assign sum=a^temp^cin;
	assign cout = (a & temp) | (temp & cin) | (cin & a);endmodule