module light_switch_controller (
        input clk,
        input areset,
        input switch_on,
        input switch_off,
        output reg light_on);parameter Light_Off=1'b0, Light_On=1'b1;
	reg state;
	always @(posedge clk, posedge areset) begin
		if (areset)
			state <= Light_Off;
		else begin
			case (state)
				Light_Off: state <= switch_on ? Light_On : Light_Off;
				Light_On: state <= switch_off ? Light_Off : Light_On;
			endcase
		end
	end
	
	assign light_on = (state == Light_On);
	
endmodule