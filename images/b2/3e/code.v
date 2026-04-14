module ring_counter(
	input clk,
	output reg [4:0] q);
initial q = 5'b00001;
always @(posedge clk) begin
		q <= {q[3:0], q[4]};
	end
endmodule