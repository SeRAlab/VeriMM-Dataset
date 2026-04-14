module top_module( ewreg,em2reg,ewmem,eAlu,eb,ern,clock,resetn,
							mwreg,mm2reg,mwmem,mAlu,mB,mrn);input ewreg,em2reg,ewmem,clock,resetn;
	input [31:0] eAlu,eb;
	input [4:0] ern;
	
	output reg mwreg,mm2reg,mwmem;
	output reg [31:0] mAlu,mB;
	output reg [4:0] mrn;
	
	always @(negedge resetn or posedge clock)
		if(resetn==0)
			begin
				mwreg<=0;
				mm2reg<=0;
				mwmem<=0;
				mAlu<=0;
				mB<=0;
				mrn<=0;
			end
		else
			begin
				mwreg<=ewreg;
				mm2reg<=em2reg;
				mwmem<=ewmem;
				mAlu<=eAlu;
				mB<=eb;
				mrn<=ern;
			end
endmodule