module top_module(input[1:0]s,input[9:0]x,input[9:0]y,input[9:0]z,input[9:0]a, output reg[9:0]f);always @(s,x,y,z,a)
	if(s==2'b00)
		f=x;
	else if(s==2'b01)
		f=y;
	else if(s==2'b10)
		f=z;
	else
		f=a;endmodule