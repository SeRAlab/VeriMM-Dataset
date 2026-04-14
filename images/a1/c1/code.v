module counter_with_enable (
	input clk,
	input reset,
	input enable,
	output reg [4:0] count);

always @(posedge clk or posedge reset) begin
	if (reset)
		count <= 5'b00000;
	else if (enable)
		count <= count + 1;
	end

endmodule