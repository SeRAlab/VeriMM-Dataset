module top_module (
        input clk,
        input areset,
        input x,
        output reg z);parameter Init=1'b0, Toggle=1'b1;
	reg state;
	always @(posedge clk, posedge areset) begin
		if (areset)
			state <= Init;
		else begin
			case (state)
				Init: state <= x ? Toggle : Init;
				Toggle: state <= x ? Init : Toggle;
			endcase
		end
	end
	
	assign z = (state == Init && x==1) | (state == Toggle && x==0);
	
endmodule