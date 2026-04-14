module top_module(a,b,cin,sum,cout,c,d,e,f,g,h,i,j);input a,b,cin;
	output sum,cout,c,d,e,f,g,h,i,j;
	assign sum=a^b^cin;
	assign cout=(a&b)|(a&cin)|(b&cin);
	assign c=1'b0;
	assign d=1'b0;
	assign e=1'b0;
	assign f=1'b0;
	assign g=1'b0;
	assign h=1'b0;
	assign i=1'b0;
	assign j=1'b0;
endmodule