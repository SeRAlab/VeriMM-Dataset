module top_module (
        input clk,
        input areset,
        input temp_high,
        input temp_low,
        output reg ac_on);parameter Off = 1'b0, On = 1'b1;
	reg state;
	always @(posedge clk, posedge areset) begin
		if (areset)
			state <= Off;
		else begin
			case (state)
				Off: state <= temp_high ? On : Off;
				On: state <= temp_low ? Off : On;
			endcase
		end
	end
	
	assign ac_on = (state == On);
	
endmodule