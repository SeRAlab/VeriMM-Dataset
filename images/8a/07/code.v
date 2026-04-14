module top_module(iCLK,iRST,oRST_0,oRST_1,oRST_2,oRST_3,oRST_4);input		iCLK;
input		iRST;
output reg	oRST_0;
output reg	oRST_1;
output reg	oRST_2;
output reg	oRST_3;
output reg	oRST_4;

reg	[31:0]	Cont;

always@(posedge iCLK or negedge iRST)
begin
	if(!iRST)
	begin
		Cont	<=	0;
		oRST_0	<=	0;
		oRST_1	<=	0;
		oRST_2	<=	0;
		oRST_3	<=	0;
		oRST_4	<=	0;
	end
	else
	begin
		if(Cont!=32'h01FFFFFF)
		Cont	<=	Cont+1;
		if(Cont>=32'h001FFFFF)
		oRST_0	<=	1;
		if(Cont>=32'h002FFFFF)
		oRST_1	<=	1;
		if(Cont>=32'h011FFFFF)
		oRST_2	<=	1;
		if(Cont>=32'h016FFFFF)
		oRST_3	<=	1;
		if(Cont>=32'h01FFFFFF)
		oRST_4	<=	1;
	end
end

endmodule