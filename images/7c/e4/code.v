module binary_counter(
	input clk,
	input rst_n,
	input enable,
	output reg [3:0] count,
	output reg overflow
);
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		count <= 4'd0;
		overflow <= 1'b0;
	end else if (enable) begin
		if (count == 4'd15) begin
			count <= 4'd0;
			overflow <= 1'b1;
		end else begin
			count <= count + 4'd1;
			overflow <= 1'b0;
		end
	end
end
endmodule