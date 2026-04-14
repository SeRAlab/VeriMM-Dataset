module up_counter (
	input clk,
	input clear,
	output reg [1:0] count
);always @(posedge clk) begin
	if (clear)
		count <= 2'b00;
	else
		count <= count + 1;
end

endmodule