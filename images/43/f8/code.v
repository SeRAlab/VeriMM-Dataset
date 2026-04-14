module top_module(iCLK,iRST,oRST_0,oRST_1,oRST_2);input		iCLK;
input		iRST;
output reg	oRST_0;
output reg	oRST_1;
output reg	oRST_2;

reg	[31:0]	Cont;

always@(posedge iCLK or negedge iRST)
begin
	if(!iRST)
	begin
		Cont	<=	0;
		oRST_0	<=	0;
		oRST_1	<=	0;
		oRST_2	<=	0;
	end
	else
	begin
		if(Cont!=32'h114FFFF)
		Cont	<=	Cont+1;
		if(Cont>=32'h1FFFFF)
		oRST_0	<=	1;
		if(Cont>=32'h2FFFFF)
		oRST_1	<=	1;
		if(Cont>=32'h114FFFF)
		oRST_2	<=	1;
	end
end

endmodule