module top_module(q, d, ce, clk);input d, ce, clk;
output reg q;

always @(posedge clk) begin
	if (ce == 1) begin	
		q <= d;		
	end
	
end

endmodule