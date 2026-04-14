module top_module(C,Display);input[2:0] C;		
	output[6:0]Display; 
	


	wire[6:0] H,E,L,O,BLANK;			
	reg[6:0]OUT;
		
	assign H[6:0] = {1'b0,1'b0,1'b0,1'b1,1'b0,1'b0,1'b1};
	assign E[6:0] = {1'b0,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0};
	assign L[6:0] = {1'b1,1'b0,1'b0,1'b0,1'b1,1'b1,1'b1};
	assign O[6:0] = {1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
	assign BLANK[6:0] = {1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1};
	
	always@(C)
		case(C)
			3'b000 : OUT = H;
			3'b001 : OUT = E;
			3'b010 : OUT = L;
			3'b011 : OUT = O;
			default : OUT = BLANK;
	endcase	
	assign Display = OUT;endmodule