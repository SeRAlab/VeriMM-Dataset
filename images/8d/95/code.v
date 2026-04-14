module top_module (
        input clk,
        input areset,
        input turn_on,
        input turn_off,
        input increase_brightness,
        input decrease_brightness,
        output reg [1:0] dimmer);parameter Off = 3'b001, Low = 3'b010, High = 3'b100;
	reg [2:0] state;
	always @(posedge clk, posedge areset) begin
		if (areset)
			state <= Off;
		else begin
			case (state)
				Off: state <= turn_on ? Low : Off;
				Low: state <= increase_brightness ? High : (turn_off ? Off : Low);
				High: state <= decrease_brightness ? Low : (turn_off ? Off : High);
			endcase
		end
	end
	
	assign dimmer = (state == Off) ? 2'b00 :
	                (state == Low) ? 2'b01 :
	                2'b10;
endmodule