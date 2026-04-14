module elevator_door_controller (
        input clk,
        input areset,
        input open_door,
        input close_door,
        output reg door_open);parameter Door_Closed=1'b0, Door_Open=1'b1;
	reg state;
	always @(posedge clk, posedge areset) begin
		if (areset)
			state <= Door_Closed;
		else begin
			case (state)
				Door_Closed: state <= open_door ? Door_Open : Door_Closed;
				Door_Open: state <= close_door ? Door_Closed : Door_Open;
			endcase
		end
	end
	
	assign door_open = (state == Door_Open);
	
endmodule