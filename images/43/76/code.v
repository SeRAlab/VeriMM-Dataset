module top_module( BCLK, SRC1, SRC2, NZEXP, OUT);input			BCLK;
	input	[31:0]	SRC1,SRC2;	
	input	 [2:1]	NZEXP;		
	
	output	reg	[36:0]	OUT;		

	wire	[47:0]	mresult;
	wire	 [9:0]	exponent,expoh,expol;
	wire	 [1:0]	restlow,resthigh;
	wire			zero,sign,orlow;
		
	assign mresult = {1'b1,SRC1[22:0]} * {1'b1,SRC2[22:0]};	

	assign zero = 	~NZEXP[2] | ~NZEXP[1];	
	assign sign = 	(SRC1[31] ^ SRC2[31]) & ~zero;
	assign orlow = 	(mresult[21:0] != 22'b0);
	
	assign restlow  = {mresult[22],orlow};
	assign resthigh = {mresult[23],(mresult[22] | orlow)};
	
	assign exponent = {2'b00,SRC1[30:23]} + {2'b00,SRC2[30:23]};
	assign expoh    = exponent - 10'h07E;
	assign expol	= exponent - 10'h07F;	
	
	always @(posedge BCLK) OUT <= mresult[47] ? {zero,sign,expoh,mresult[46:24],resthigh}
											  : {zero,sign,expol,mresult[45:23],restlow};endmodule