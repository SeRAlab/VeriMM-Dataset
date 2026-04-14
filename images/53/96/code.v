module washing_machine_controller (
        input clk,
        input areset,
        input start_wash,
        input wash_done,
        output reg washing);parameter Idle=1'b0, Wash=1'b1;
	reg state;
	always @(posedge clk, posedge areset) begin
		if (areset)
			state <= Idle;
		else begin
			case (state)
				Idle: state <= start_wash ? Wash : Idle;
				Wash: state <= wash_done ? Idle : Wash;
			endcase
		end
	end
	
	assign washing = (state == Wash);
	
endmodule