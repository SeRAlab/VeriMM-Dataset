module washing_machine (
        input clk,
        input areset,
        input start_washing,
        input wash_done,
        output reg washing);parameter Idle=1'b0, Washing=1'b1;
	reg state;
	always @(posedge clk or posedge areset) begin
		if (areset)
			state <= Idle;
		else begin
			case (state)
				Idle: state <= start_washing ? Washing : Idle;
				Washing: state <= wash_done ? Idle : Washing;
			endcase
		end
	end
	
	assign washing = (state == Washing);
	
endmodule