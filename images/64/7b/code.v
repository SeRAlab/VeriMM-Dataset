module top_module (
	input clk,
	input areset,
	input x,
	output z);parameter EVEN=0, ODD=1;
	reg state;
	always @(posedge clk, posedge areset) begin
		if (areset)
			state <= EVEN;
		else begin
			case (state)
				EVEN: state <= x ? ODD : EVEN;
				ODD: state <= x ? EVEN : ODD;
			endcase
		end
	end
	
	assign z = (state == EVEN);
	
endmodule