module sync_counter(
	input clk,
	input enable,
	input reset,
	output reg [2:0] count);
always @(posedge clk) begin
	if (reset)
		count <= 0;
	else if (enable)
		count <= count + 1;
end

endmodule