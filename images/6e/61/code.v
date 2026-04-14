module top_module(SRC1, SRC2, BWD, FLAG, DOUT);input	[31:0]	SRC1;
	input	 [4:0]	SRC2;
	input	 [1:0]	BWD;
	output	reg		FLAG;
	output	 [4:0]	DOUT;

	reg		 [6:0]	maske;
	reg		 [7:0]	byte_1,byte_2;
	
	wire	 [7:0]	byte_0,byte_3;
	wire	[15:0]	mdat_0;
	wire	 [7:0]	mdat_1;
	wire	 [3:0]	mdat_2;
	wire	 [1:0]	mdat_3;
	wire	 [4:0]	obits;
	
	always @(*)
		case (SRC2[2:0])
		  3'd0 : maske = 7'h7F;
		  3'd1 : maske = 7'h7E;
		  3'd2 : maske = 7'h7C;
		  3'd3 : maske = 7'h78;
		  3'd4 : maske = 7'h70;
		  3'd5 : maske = 7'h60;
		  3'd6 : maske = 7'h40;
		  3'd7 : maske = 7'h00;
		endcase
		
	assign byte_0 = (SRC2[4:3] == 2'b00) ? {SRC1[7],(SRC1[6:0] & maske)} : 8'h00;
	
	always @(*)
		casex (SRC2[4:3])
		  2'b00 : byte_1 = SRC1[15:8];
		  2'b01 : byte_1 = {SRC1[15],(SRC1[14:8] & maske)}; 
		  2'b1x : byte_1 = 8'h00;
		endcase
		
	always @(*)
		casex (SRC2[4:3])
		  2'b0x : byte_2 = SRC1[23:16];
		  2'b10 : byte_2 = {SRC1[23],(SRC1[22:16] & maske)}; 
		  2'b11 : byte_2 = 8'h00;
		endcase
		
	assign byte_3 = (SRC2[4:3] == 2'b11) ? {SRC1[31],(SRC1[30:24] & maske)} : SRC1[31:24];

	assign obits[4] = ({byte_1,byte_0} == 16'h0);
	assign mdat_0	= obits[4] ? {byte_3,byte_2} : {byte_1,byte_0};	

	assign obits[3]	= (mdat_0[7:0] == 8'h0);
	assign mdat_1	= obits[3] ? mdat_0[15:8] : mdat_0[7:0];

	assign obits[2] = (mdat_1[3:0] == 4'h0);
	assign mdat_2	= obits[2] ? mdat_1[7:4] : mdat_1[3:0];
	
	assign obits[1] = (mdat_2[1:0] == 2'b0);
	assign mdat_3	= obits[1] ? mdat_2[3:2] : mdat_2[1:0];
	
	assign obits[0] = ~mdat_3[0];
	
	always @(BWD or obits or mdat_3)
		casex ({BWD,obits[4:3]})
		  4'b00_x1 : FLAG = 1;	
		  4'b00_10 : FLAG = 1;	
		  4'b01_1x : FLAG = 1;	
		  default  : FLAG = (mdat_3 == 2'b00);
		endcase

	assign DOUT = FLAG ? 5'h0 : obits;
	
endmodule