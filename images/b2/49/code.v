module top_module(BusA, BusB, BusW, RA, RB, RW, RegWr, Clk);output [63:0] BusA, BusB;
	input [63:0] BusW;
	input [4:0] RA, RB, RW;
	input RegWr;
	input Clk;
	
	reg [64:0] registerfile [31:0];
	
	assign BusA = (RA == 31)?0:registerfile[RA];
	assign BusB = (RB == 31)?0:registerfile[RB];


		always @ (negedge Clk) 
	begin
		if(RegWr && RW != 5'b11111) 
		registerfile[RW] <= BusW;
		else if(RegWr && RW == 5'b11111)
			registerfile[RW] <= 0;
	end
endmodule