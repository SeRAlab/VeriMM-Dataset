module heater_controller (
        input clk,
        input areset,
        input temperature_low,
        input temperature_high,
        output reg heater_on);parameter Off=1'b0, On=1'b1;
	reg state;
	always @(posedge clk, posedge areset) begin
		if (areset)
			state <= Off;
		else begin
			case (state)
				Off: state <= temperature_low ? On : Off;
				On: state <= temperature_high ? Off : On;
			endcase
		end
	end
	
	assign heater_on = (state == On);
	
endmodule