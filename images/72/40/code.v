module top_module(
	input clk,
	input rst,
	input [2:0] state,
	output [3:0] BCD0,
	output [3:0] BCD1
);parameter [2:0] MENU  = 3'b000;
parameter [2:0] GAME  = 3'b001;
parameter [2:0] P1WIN = 3'b010;
parameter [2:0] P2WIN = 3'b011;
parameter [2:0] TIE   = 3'b100;
parameter [2:0] PIONT = 3'b101;

parameter game_time = 60;

reg [6:0] timer, next_timer;

always @(posedge clk, posedge rst) begin
	if (rst) begin
		timer <= game_time;
	end else begin
		timer <= next_timer;
	end
end

always @(*) begin
	case (state)
		MENU:
			next_timer = game_time;
		GAME:
			next_timer = timer - 1;
		P1WIN:
			next_timer = game_time;
		P2WIN:
			next_timer = game_time;
		TIE:
			next_timer = game_time;
		PIONT:
			next_timer = game_time;
		default: 
			next_timer = timer;
	endcase
end

assign BCD0 = (state == GAME) ? timer % 10 : 10;
assign BCD1 = (state == GAME) ? timer / 10 : 10;

endmodule