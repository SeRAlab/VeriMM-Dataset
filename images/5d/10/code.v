module top_module(clk, rst, bossHP, playerHP, gameState
    );input clk, rst;
	input [9:0] bossHP;
	input [1:0] playerHP;
	output reg [1:0] gameState;
	
	always @ (posedge clk) begin
		if (rst)
			gameState <= 2'b00;
		else if (bossHP <= 0)
			gameState <= 2'b01;
		else if (playerHP <= 0)
			gameState <= 2'b10;
		else
			gameState <= 2'b00;
	end


endmodule