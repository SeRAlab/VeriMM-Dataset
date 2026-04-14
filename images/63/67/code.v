module down_counter(
	input wire clk,
	input wire rst,
	output reg [2:0] count
);always @(posedge clk or posedge rst) begin
	if (rst)
		count <= 3'b111;
	else
		count <= count - 1;
end
endmodule