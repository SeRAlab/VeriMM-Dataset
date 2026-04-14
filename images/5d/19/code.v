module microwave_controller (
        input clk,
        input areset,
        input start_button,
        input stop_button,
        output reg microwave_on);parameter Off=1'b0, On=1'b1;
	reg state;
	always @(posedge clk, posedge areset) begin
		if (areset)
			state <= Off;
		else begin
			case (state)
				Off: state <= start_button ? On : Off;
				On: state <= stop_button ? Off : On;
			endcase
		end
	end
	
	assign microwave_on = (state == On);
	
endmodule