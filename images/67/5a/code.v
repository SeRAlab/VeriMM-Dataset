module top_module (
	input reset,
	input set,
	output reg q);always @(*) begin
	if (reset)
		q <= 0;
	else if (set)
		q <= 1;
end

endmodule