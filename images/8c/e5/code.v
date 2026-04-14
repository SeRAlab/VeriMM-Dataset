module top_module(
	input clk,
	input load_enable,
	input [5:0] load_value,
	output reg [5:0] count);
always @(posedge clk) begin
	if (load_enable)
		count <= load_value;
	else
		count <= count + 1;
end
	
endmodule