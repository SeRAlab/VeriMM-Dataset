module top_module (
        input clk,
        input areset,
        input timer,
        output reg [1:0] light);parameter Green=2'b00, Yellow=2'b01, Red=2'b10;
	reg [1:0] state;
	always @(posedge clk, posedge areset) begin
		if (areset)
			state <= Green;
		else begin
			case (state)
				Green: state <= timer ? Yellow : Green;
				Yellow: state <= timer ? Red : Yellow;
				Red: state <= timer ? Green : Red;
			endcase
		end
	end
	
	assign light = state;
	
endmodule