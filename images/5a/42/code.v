module top_module(LED,iCLK,iRST_N);output	[7:0]	LED;
input			iCLK;
input			iRST_N;

reg		[20:0]	Cont;
reg		[7:0]	mLED;
reg				DIR;

always@(posedge iCLK)	Cont	<=	Cont+1'b1;

always@(posedge Cont[20] or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		mLED	<=	8'b00000111;
		DIR		<=	0;
	end
	else
	begin
		if(!DIR)
		mLED	<=	{mLED[6:0],mLED[7]};
		else
		mLED	<=	{mLED[0],mLED[7:1]};
		if(mLED == 8'b01110000)
		DIR	<=	1;
		else if(mLED == 8'b00001110)
		DIR	<=	0;
	end
end

assign	LED	=	mLED;

endmodule