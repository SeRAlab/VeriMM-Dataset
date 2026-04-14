module ring_counter (
	input clk,
	input resetn,
	output reg [4:0] q);

always @(posedge clk) begin
	if (~resetn)
		q <= 5'b00001;
	else
		q <= {q[3:0], q[4]};
end

endmodule