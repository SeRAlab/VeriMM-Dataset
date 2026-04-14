module top_module(A, B, S, Ai, Bi, Ar, Br, clk, So, sub);input [7:0]A;
	input [7:0]B;
	input Ai, Bi, Ar, Br, clk, So, sub;
	output [7:0]S;
	wire Ao, Bo;
	reg[7:0]At;
	reg[7:0]Bt;
	reg[7:0]St;
	
	always@(clk)begin
		if(Ai==1'b1) At <= A;
		else if(Ar==1'b1) At <= 8'b00000000;
	end
	always@(clk)begin
		if(Bi==1'b1) Bt <= B;
		else if(Br==1'b1) Bt <= 8'b00000000;
	end
	always@(clk)begin
		if(sub==1'b1) St <= A-B;
		else St <= A+B;
	end
	assign Ao = At;
	assign Bo = Bt;
	assign S = (So==1'b1) ? St
					: 8'b00000000;
endmodule