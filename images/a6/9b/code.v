module enable_clear_counter (
	input clk,
	input clear,
	input enable,
	output reg [9:0] count);always @(posedge clk)
begin
	if (clear)
		count <= 10'b0000000000;
	else if (enable)
		count <= count + 1;
end

endmodule