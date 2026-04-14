module top_module(address, WE,dataIn, dataOut, clock, testStart);input [7:0] dataIn;
input [4:0] address;
input WE, clock;
input testStart;
output reg[7:0] dataOut;

reg [7:0] RAM[31:0];

always @ (posedge clock)
begin
	if(testStart == 1'b1)
		begin
			RAM[5'd0] <= 8'b10000000;
			RAM[5'd1] <= 8'b00111110;
			RAM[5'd2] <= 8'b10000000;
			RAM[5'd3] <= 8'b00111111;
			RAM[5'd4] <= 8'b00011110;
			RAM[5'd5] <= 8'b01111111;
			RAM[5'd6] <= 8'b10110000;
			RAM[5'd7] <= 8'b11001100;
			RAM[5'd8] <= 8'b00011111;
			RAM[5'd9] <= 8'b01111110;
			RAM[5'd10] <= 8'b00111111;
			RAM[5'd11] <= 8'b11000100;
			RAM[5'd12] <= 8'b00011110;
			RAM[5'd13] <= 8'b01111111;
			RAM[5'd14] <= 8'b00111110;
			RAM[5'd15] <= 8'b11000100;
			RAM[5'd16] <= 8'b00011110;
			RAM[5'd17] <= 8'b11111111;
			
			
		end
		
	if( WE == 1'b1)
		RAM[address] <= dataIn;

	else
		dataOut <= RAM[address];
end

endmodule