module elevator_controller (
        input clk,
        input areset,
        input go_up,
        input go_down,
        input floor_reached,
        output reg door_open,
        output reg moving_up,
        output reg moving_down);parameter Idle=2'b00, Moving_Up=2'b01, Moving_Down=2'b10;
	reg [1:0] state;
	always @(posedge clk or posedge areset) begin
		if (areset)
			state <= Idle;
		else begin
			case (state)
				Idle: 
					if (go_up) state <= Moving_Up;
					else if (go_down) state <= Moving_Down;
				Moving_Up:
					if (floor_reached) state <= Idle;
				Moving_Down:
					if (floor_reached) state <= Idle;
			endcase
		end
	end
	
	assign door_open = (state == Idle);
	assign moving_up = (state == Moving_Up);
	assign moving_down = (state == Moving_Down);
	
endmodule