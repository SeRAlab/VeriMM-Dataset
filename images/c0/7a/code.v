module	VGA_Ctrl	(	
						iRed,
						iGreen,
						iBlue,
						oCurrent_X,
						oCurrent_Y,
						oVGA_R,
						oVGA_G,
						oVGA_B,
						oVGA_HS,
						oVGA_VS,
						oVGA_SYNC,
						oVGA_BLANK,
						oVGA_CLOCK,
						iCLK,
						iRST_N,
						les_btn );
input wire les_btn;						
input		[9:0]	iRed;
input		[9:0]	iGreen;
input		[9:0]	iBlue;
output		[10:0]	oCurrent_X;
output		[10:0]	oCurrent_Y;
output		[9:0]	oVGA_R;
output		[9:0]	oVGA_G;
output		[9:0]	oVGA_B;
output	reg			oVGA_HS;
output	reg			oVGA_VS;
output				oVGA_SYNC;
output				oVGA_BLANK;
output				oVGA_CLOCK;
input				iCLK;
input				iRST_N;	
reg			[10:0]	H_Cont;
reg			[10:0]	V_Cont;
parameter	H_FRONT	=	16;
parameter	H_SYNC	=	96;
parameter	H_BACK	=	48;
parameter	H_ACT	=	640;
parameter	V_FRONT	=	10;
parameter	V_SYNC	=	2;
parameter	V_BACK	=	33;
parameter	V_ACT	=	480;
parameter	H_BLANK	=	H_FRONT+H_SYNC+H_BACK;
parameter	H_TOTAL	=	H_FRONT+H_SYNC+H_BACK+H_ACT;
parameter	V_BLANK	=	V_FRONT+V_SYNC+V_BACK;
parameter	V_TOTAL	=	V_FRONT+V_SYNC+V_BACK+V_ACT;
assign	oVGA_SYNC	=	1'b1;			
assign	oVGA_BLANK	=	~((H_Cont<H_BLANK)||(V_Cont<V_BLANK));
assign	oVGA_CLOCK	=	~iCLK;
assign	oVGA_R		=	(oCurrent_X > 0) ?	iRed : 0 ;
assign	oVGA_G		=	(oCurrent_X > 0) ?	iGreen : 0 ;
assign	oVGA_B		=	(oCurrent_X > 0) ?	iBlue : 0 ;
assign	oCurrent_X	=	(H_Cont>=H_BLANK)	?	H_Cont-H_BLANK	:	11'h0	;
assign	oCurrent_Y	=	(V_Cont>=V_BLANK)	?	V_Cont-V_BLANK	:	11'h0	;
reg [7:0] btn_cnt;
always@(posedge les_btn)
begin
	btn_cnt= btn_cnt +8'h1;
end
always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		H_Cont		<=	0;
		oVGA_HS		<=	1;
	end
	else
	begin
		if(H_Cont<H_TOTAL-1)
		H_Cont	<=	H_Cont+1'b1;
		else
		H_Cont	<=	0;
		if(H_Cont==H_FRONT-1)			
		oVGA_HS	<=	1'b0;
		else if(H_Cont==H_FRONT+H_SYNC-1)	
		oVGA_HS	<=	1'b1;
	end
end
always@(posedge oVGA_HS or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		V_Cont		<=	0;
		oVGA_VS		<=	1;
	end
	else
	begin
		if(V_Cont<V_TOTAL-1)
			V_Cont	<=	V_Cont+1'b1;
		else
			V_Cont	<=	0;
		if(V_Cont==V_FRONT-1)			
			oVGA_VS	<=	1'b0;
		if(V_Cont==V_FRONT+V_SYNC-1)	
			oVGA_VS	<=	1'b1;
	end
end
endmodule