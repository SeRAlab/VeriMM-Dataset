module top_module(SRC, BWD, NOT_DEI, EXTDATA, DOUT, MSB, NULL, MINUS);input	[31:0]	SRC;
	input	 [1:0]	BWD;
	input			NOT_DEI;
	input			EXTDATA;
	
	output	[31:0]	DOUT;
	output	 [4:0]	MSB;
	output			NULL;
	output			MINUS;

	reg		[31:0]	double;
	
	wire	[15:0]	test_16;
	wire	 [7:0]	test_8;
	wire	 [3:0]	test_4;
	wire	 [1:0]	test_2;
	wire			bit_4,bit_3,bit_2,bit_1,bit_0;
	wire	 [1:0]	modus;
	
	assign modus = (NOT_DEI | EXTDATA) ? BWD : {(BWD[1] | BWD[0]),1'b1};
	
	always @(modus or SRC or NOT_DEI)
		casex (modus)
		  2'b00 : double = {{24{SRC[7]  & NOT_DEI}},SRC[7:0]};
		  2'b01 : double = {{16{SRC[15] & NOT_DEI}},SRC[15:0]};
		  2'b1x : double = SRC;
		endcase
		
	assign MINUS = double[31] & NOT_DEI;
	
	assign DOUT = ({32{MINUS}} ^ double) + {31'h0,MINUS};	
	
	
	
	assign bit_4   = (DOUT[31:16] != 16'h0);
	assign test_16 = bit_4 ? DOUT[31:16]   : DOUT[15:0];
	assign bit_3   = (test_16[15:8] != 8'h0);
	assign test_8  = bit_3 ? test_16[15:8] : test_16[7:0];
	assign bit_2   = (test_8[7:4] != 4'h0);
	assign test_4  = bit_2 ? test_8[7:4]   : test_8[3:0];
	assign bit_1   = (test_4[3:2] != 2'b0);
	assign test_2  = bit_1 ? test_4[3:2]   : test_4[1:0];
	assign bit_0   =  test_2[1];
	assign NULL    = (test_2 == 2'b00);
	
	assign MSB = {bit_4,bit_3,bit_2,bit_1,bit_0};
	
endmodule