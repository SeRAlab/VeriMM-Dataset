module top_module (
        input clk,
        input areset,
        input temp_below_threshold,
        input temp_above_threshold,
        output reg heating);parameter Off = 2'b01, On = 2'b10;
	reg [1:0] state;
	always @(posedge clk, posedge areset) begin
		if (areset)
			state <= Off;
		else begin
			case (state)
				Off: state <= temp_below_threshold ? On : Off;
				On: state <= temp_above_threshold ? Off : On;
			endcase
		end
	end
	
	assign heating = (state == On);
endmodule