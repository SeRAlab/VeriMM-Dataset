module johnson_counter_4bit (
	input clk,
	input rst,
	output reg [3:0] q);
always @(posedge clk or negedge rst) begin
	if (!rst) begin
		q <= 4'b0000;
	end else begin
		q <= {q[2:0], ~q[3]};
	end
end
endmodule