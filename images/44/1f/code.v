module up_down_counter(
	input wire clk,
	input wire reset,
	input wire dir,
	output reg [1:0] count
);always @(posedge clk) begin
	if (reset)
		count <= 2'b00;
	else if (dir)
		count <= count + 1;
	else
		count <= count - 1;
end
endmodule