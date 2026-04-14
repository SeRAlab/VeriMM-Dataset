module top_module (
	input clk,
	output reg [3:0] q);

initial q = 4'b0001;

always @(posedge clk) begin
	q <= {q[2:0], q[3]};
end

endmodule