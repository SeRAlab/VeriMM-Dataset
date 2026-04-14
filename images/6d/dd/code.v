module top_module (
        input clk,
        input areset,
        input start_button,
        input wash_complete,
        output reg washing);parameter Idle = 1'b0, Washing = 1'b1;
	reg state;
	always @(posedge clk, posedge areset) begin
		if (areset)
			state <= Idle;
		else begin
			case (state)
				Idle: state <= start_button ? Washing : Idle;
				Washing: state <= wash_complete ? Idle : Washing;
			endcase
		end
	end
	
	assign washing = (state == Washing);
	
endmodule