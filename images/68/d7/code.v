module down_counter (
	input clk,
	input reset,
	input load,
	input [3:0] load_value,
	output reg [3:0] count);always @(posedge clk or posedge reset)
begin
	if (reset)
		count <= load_value;
	else if (load)
		count <= load_value;
	else
		count <= count - 1;
end

endmodule