module top_module(clock,writeEn,address,ramOut,dataIn,reset);input clock,writeEn,reset;
	input [4:0]address;
	input [7:0]dataIn;
	output reg[7:0]ramOut;
	
	reg [7:0]RAM[31:0];
	

always@(posedge clock,negedge reset)
	if(!reset)begin
		RAM[5'b00000] <= 8'b10000000;
		RAM[5'b00001] <= 8'b01111111;
		RAM[5'b00010] <= 8'b10100100;
		RAM[5'b00011] <= 8'b11000001;
		RAM[5'b00100] <= 8'b11111111;
		RAM[5'b11111] <= 8'b00000001;
		
	end
	else
		if(writeEn)
			RAM[address] <= dataIn;
		else 
			ramOut <= RAM[address];

endmodule