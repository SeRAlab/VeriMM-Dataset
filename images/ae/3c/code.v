module garage_door (
        input clk,
        input areset,
        input open_button,
        input close_button,
        output reg door_open);parameter Closed=1'b0, Open=1'b1;
	reg state;
	always @(posedge clk, posedge areset) begin
		if (areset)
			state <= Closed;
		else begin
			case (state)
				Closed: state <= open_button ? Open : Closed;
				Open: state <= close_button ? Closed : Open;
			endcase
		end
	end
	
	assign door_open = (state == Open);
	
endmodule