module down_counter (
	input clk,
	input set,
	output reg [1:0] count);always @(posedge clk or posedge set) begin
	if (set)
		count <= 2'b11;
	else
		count <= count - 1;
end

endmodule