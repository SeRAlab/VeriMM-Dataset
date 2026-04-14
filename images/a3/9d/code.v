module up_counter (
	input clk,
	input en,
	input resetn,
	output reg [7:0] q);

always @(posedge clk) begin
	if (~resetn)
		q <= 8'b00000000;
	else if (en)
		q <= q + 1;
end

endmodule