module top_module(
		input wire fresh,
		input wire [9:0] x,
		input wire [8:0] y,
		input wire fly_button,
		input wire RESET,
		input wire START,
		input wire Lose,
		input wire game_status,
		input wire [31:0] clkdiv,
		output reg is_bird,
		output reg [8:0] bird_y
	 );parameter bird_x = 10'd120;
	 
	 
	 parameter a = 9'b1;
	 
	 
	 reg [8:0] velocity;
	 
	 
	 always@(negedge fresh) begin	
		if(game_status)begin
			if(fly_button)begin		
				velocity <= -9'd4;
				bird_y <= bird_y + velocity;
			end
			else begin
				velocity <= velocity + a;
				bird_y <= bird_y + velocity;
			end
		end else begin
			if( (~Lose) || RESET)begin	
				bird_y <= 9'd240;
				velocity <= 9'd0;
			end
		end
	 end
	 
	 
	 always@(posedge clkdiv[0])begin
		if(x >= bird_x && x < bird_x + 10'd48 && y >= bird_y && y < bird_y + 10'd48)begin
			is_bird <= 1'b1;
		end
		else begin
			is_bird <= 1'b0;
		end
	 end

endmodule