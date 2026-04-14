module counter_with_load (
	input clk,
	input reset,
	input load,
	input [1:0] load_value,
	output reg [1:0] count);always @(posedge clk) begin
	if (reset) begin
		count <= 2'b00;
	end else if (load) begin
		count <= load_value;
	end else begin
		count <= count + 1;
	end
end

endmodule