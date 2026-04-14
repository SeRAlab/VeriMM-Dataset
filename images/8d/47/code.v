module top_module (
	input clk,
	input sreset,
	input a,
	input b,
	output p);parameter EVEN=0, ODD=1;
	reg state;
	always @(posedge clk) begin
		if (sreset)
			state <= EVEN;
		else begin
			case (state)
				EVEN: state <= (a ^ b) ? ODD : EVEN;
				ODD: state <= (a ^ b) ? EVEN : ODD;
			endcase
		end
	end
	
	assign p = (state == EVEN);
	
endmodule