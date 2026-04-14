module up_down_counter (
	input clk,
	input up_down,
	output reg [3:0] count);always @(posedge clk) begin
	if (up_down) begin
		count <= count + 4'b0001;
	end else begin
		count <= count - 4'b0001;
	end
end

endmodule