module top_module(evaluateCollision, xBird, yBird, xPipe, yPipe, resetLow, clk, height, width, collisionHappen);input evaluateCollision;
	input [7:0] xBird;
	input [6:0] yBird;
	
	input [7:0] xPipe;
	input [6:0] yPipe;
	input resetLow;
	input [7:0] height;
	input [4:0] width;
	input clk;
	output reg collisionHappen;
	
	
	always@(posedge clk)
	if (!resetLow)
		collisionHappen <= 1'b0;
	else
	begin
		if (evaluateCollision)
		begin
			if (collisionHappen == 0) 
			begin
				if (xPipe - 4 <= xBird && xBird <= xPipe + width && yBird <= yPipe + 1)
					collisionHappen <= 1'b1;
				else if (xPipe - 4 <= xBird && xBird <= xPipe + width && yBird >= yPipe + height - 4)
					collisionHappen <= 1'b1;
				else
					collisionHappen <= 1'b0; 
			end
			else
				collisionHappen <= 1'b1;
		end
	end
	
endmodule