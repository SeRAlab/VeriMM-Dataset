module top_module (
        input clk,
        input areset,
        input timer_expired,
        output reg [1:0] light);parameter Red = 2'b00, Green = 2'b01, Yellow = 2'b10;
	reg [1:0] state;
	always @(posedge clk, posedge areset) begin
		if (areset)
			state <= Red;
		else begin
			case (state)
				Red: state <= timer_expired ? Green : Red;
				Green: state <= timer_expired ? Yellow : Green;
				Yellow: state <= timer_expired ? Red : Yellow;
			endcase
		end
	end
	
	assign light = state;
	
endmodule