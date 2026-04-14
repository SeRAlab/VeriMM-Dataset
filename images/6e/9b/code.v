module top_module(
	input clk,
	input enable,
	input load,
	input clear,
	input [9:0] load_value,
	output reg [9:0] count);
always @(posedge clk) begin
	if (clear)
		count <= 0;
	else if (load)
		count <= load_value;
	else if (enable)
		count <= count + 1;
end
	
endmodule