module johnson_counter (
	input clk,
	input en,
	output reg [7:0] q);

always @(posedge clk) begin
	if (~en)
		q <= q;
	else
		q <= {~q[0], q[7:1]};
end

endmodule