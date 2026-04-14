module top_module (
        input clk,
        input areset,
        input start_heating,
        input stop_heating,
        output reg heater_on);parameter Heater_Off=1'b0, Heater_On=1'b1;
	reg state;
	always @(posedge clk, posedge areset) begin
		if (areset)
			state <= Heater_Off;
		else begin
			case (state)
				Heater_Off: state <= start_heating ? Heater_On : Heater_Off;
				Heater_On: state <= stop_heating ? Heater_Off : Heater_On;
			endcase
		end
	end
	
	assign heater_on = (state == Heater_On);
	
endmodule