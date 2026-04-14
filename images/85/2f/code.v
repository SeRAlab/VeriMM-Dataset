module top_module (
        input clk,
        input areset,
        input x,
        output reg z);parameter Red=2'b00, Green=2'b01, Yellow=2'b10;
	reg [1:0] state;
	always @(posedge clk, posedge areset) begin
		if (areset)
			state <= Red;
		else begin
			case (state)
				Red: state <= x ? Red : Green;
				Green: state <= x ? Green : Yellow;
				Yellow: state <= x ? Yellow : Red;
			endcase
		end
	end
	
	assign z = (state == Red);
	
endmodule