module jk_flip_flop (
	input clk, reset, J, K,
	output reg q);always @(posedge clk) begin
	if (reset) 
		q <= 1'b0;
	else if (J && ~K) 
		q <= 1'b1;
	else if (~J && K) 
		q <= 1'b0;
	else if (J && K) 
		q <= ~q;
end

endmodule