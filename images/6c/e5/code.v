module johnson_counter #(
	parameter N = 4
)(
	input clk,
	input rst,
	output reg [N-1:0] q
);

always @(posedge clk or posedge rst) begin
	if (rst) begin
		q <= {N{1'b0}};
	end else begin
		q <= {~q[N-1], q[N-1:1]};
	end
end

endmodule