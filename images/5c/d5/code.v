module top_module( DIN, IPOS, INIT, OPOS, VALID);// Detects set bits in register list for SAVE/RESTORE & ENTER/EXIT

	input	 [7:0]	DIN;
	input	 [2:0]	IPOS;
	input			INIT;
	output	 [2:0]	OPOS;
	output			VALID;
	
	reg		 [7:1]	filter;
	wire	 [7:0]	mdat_0;
	wire	 [3:0]	mdat_1;
	wire	 [1:0]	mdat_2;

	always @(IPOS or DIN)
		case (IPOS)
		  3'd0 : filter =  DIN[7:1];
		  3'd1 : filter = {DIN[7:2],1'b0};
		  3'd2 : filter = {DIN[7:3],2'b0};
		  3'd3 : filter = {DIN[7:4],3'b0};
		  3'd4 : filter = {DIN[7:5],4'b0};
		  3'd5 : filter = {DIN[7:6],5'b0};
		  3'd6 : filter = {DIN[7]  ,6'b0};
		  3'd7 : filter =           7'b0;
		endcase
		
	assign mdat_0  = INIT ? DIN : {filter,1'b0};
	assign OPOS[2] = (mdat_0[3:0] == 4'h0);
	assign mdat_1  = OPOS[2] ? mdat_0[7:4] : mdat_0[3:0];
	assign OPOS[1] = (mdat_1[1:0] == 2'b00);
	assign mdat_2  = OPOS[1] ? mdat_1[3:2] : mdat_1[1:0];
	assign OPOS[0] = ~mdat_2[0];
	assign VALID   = (mdat_2 != 2'b00);
	
endmodule