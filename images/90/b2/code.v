module elevator_controller (
        input clk,
        input areset,
        input up_button,
        input down_button,
        output reg [1:0] floor);parameter Ground=2'b00, First=2'b01, Second=2'b10, Third=2'b11;
	reg [1:0] state;
	always @(posedge clk, posedge areset) begin
		if (areset)
			state <= Ground;
		else begin
			case (state)
				Ground: state <= up_button ? First : Ground;
				First: state <= up_button ? Second : (down_button ? Ground : First);
				Second: state <= up_button ? Third : (down_button ? First : Second);
				Third: state <= down_button ? Second : Third;
			endcase
		end
	end
	
	assign floor = state;
	
endmodule