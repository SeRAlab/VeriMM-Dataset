module top_module(
	clk,
	reset_n,
	life,
	level,
	finish,
	win,
	game_over,
	game_won
	);input clk, reset_n, finish, win;
	output reg [4:0] life, level;
	output reg game_over, game_won;
	
	always @(posedge clk) begin
		if (~reset_n) begin
			level <= 5'd1;
			life <= 5'd3;
			game_over <= 0;
			game_won <= 0;
		end
		
		else begin
			
			if (finish) begin
				
				if (win) begin
					
					if (level == 5'd10) begin
						game_won <= 1;
						life <= life;
						game_over <= 0;
						level <= level;
					end
					
					
					else begin
						game_won <= 0;
						game_over <= 0;
						life <= life + 1;
						level <= level + 1;
					end
				end
				
				
				else begin
					
					if (life == 5'd1) begin
						life <= 5'd0;
						game_won <= 0;
						game_over <= 1;
						level <= level;
					end
					
					
					else begin
						life <= life - 1;
						game_over <= 0;
						game_won <= 0;
						level <= level;
					end
				end
			end
		end
	end
	
endmodule