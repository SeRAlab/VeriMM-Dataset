module top_module (
        input clk,
        input areset,
        input start_sprinkler,
        input stop_sprinkler,
        output reg sprinkler_on);parameter Sprinkler_Off=1'b0, Sprinkler_On=1'b1;
	reg state;
	always @(posedge clk, posedge areset) begin
		if (areset)
			state <= Sprinkler_Off;
		else begin
			case (state)
				Sprinkler_Off: state <= start_sprinkler ? Sprinkler_On : Sprinkler_Off;
				Sprinkler_On: state <= stop_sprinkler ? Sprinkler_Off : Sprinkler_On;
			endcase
		end
	end
	
	assign sprinkler_on = (state == Sprinkler_On);
	
endmodule