module top_module(
	clk,nrst,
	RegWrite,
	rreg1, rreg2,
	wra, wrd,
	rd1, rd2
	);input clk;
	input nrst;
	input RegWrite;
	input [4:0] rreg1;
	input [4:0] rreg2;
	input [4:0] wra;
	input [31:0] wrd;
	output [31:0] rd1;
	output [31:0] rd2;
	
	reg [31:0] rd1;
	reg [31:0] rd2;

	reg [31:0] r [31:0];
	integer i;
	always@(*)begin
		rd1<=r[rreg1];
		rd2<=r[rreg2];
	end
	always@(posedge clk or negedge nrst)begin
		if(!nrst)
			for (i=0;i<32;i=i+1)begin
				r[i] <=32'd0;			
			end
		else begin
			if(RegWrite)r[wra]<=wrd;
		end
			
	end
	
endmodule