module fan_controller (
        input clk,
        input areset,
        input turn_on,
        input turn_off,
        output reg fan_on);parameter Off=1'b0, On=1'b1;
	reg state;
	always @(posedge clk, posedge areset) begin
		if (areset)
			state <= Off;
		else begin
			case (state)
				Off: state <= turn_on ? On : Off;
				On: state <= turn_off ? Off : On;
			endcase
		end
	end
	
	assign fan_on = (state == On);
	
endmodule