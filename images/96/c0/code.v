module top_module(
		input [9:0] xPos,
		input [9:0] yPos,		
		input [1:0] snake,
		input [5:0] foodX,
		input [5:0] foodY,		
		output reg [11:0] vgaData
    );localparam NONE = 2'b00;
		localparam HEAD = 2'b01;
		localparam BODY = 2'b10;
		localparam WALL = 2'b11;


	
		always @ (*)
		begin
			 if (xPos[9:4]==foodX && yPos[9:4] == foodY)
			 begin
				vgaData=12'b111100000000;
			 end
			 else  if (snake==NONE)
			 begin
				vgaData=12'b000000000000;
			 end 
			 else if (snake == WALL)
			 begin
				vgaData=12'b000011111111;
			 end 
			 else if (snake == HEAD) 
			 begin
				vgaData=12'b000011110000;
			 end
			 else if (snake == BODY)
			 begin
				vgaData=12'b111111110000;
			 end 
		end
endmodule