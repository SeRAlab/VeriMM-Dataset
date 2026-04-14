module top_module (
        input clk,
        input areset,
        input x,
        output reg z);parameter Low=1'b0, High=1'b1;
	reg state;
	always @(posedge clk, posedge areset) begin
		if (areset)
			state <= Low;
		else begin
			case (state)
				Low: state <= x ? High : Low;
				High: state <= Low;
			endcase
		end
	end
	
	assign z = (state == Low && x==1);
	
endmodule