module top_module(Din,Dout);input [15:0]Din;
	output reg [31:0]Dout;
	reg [15:0] temp;
	always@(Din)begin
	temp=Din;
	Dout[3:0]=temp%10;
	temp=temp/10;
	Dout[7:4]=temp%10;
	temp=temp/10;
	Dout[11:8]=temp%10;	
	temp=temp/10;
	Dout[15:12]=temp%10;	
	Dout[31:16]=0;	
	end
	
endmodule