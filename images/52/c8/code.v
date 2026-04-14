module top_module (
        input clk,
        input areset,
        input correct_code,
        input incorrect_code,
        output reg lock);parameter Locked=1'b0, Unlocked=1'b1;
	reg state;
	always @(posedge clk, posedge areset) begin
		if (areset)
			state <= Locked;
		else begin
			case (state)
				Locked: state <= correct_code ? Unlocked : Locked;
				Unlocked: state <= incorrect_code ? Locked : Unlocked;
			endcase
		end
	end
	
	assign lock = (state == Locked);
	
endmodule