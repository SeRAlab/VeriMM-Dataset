module binary_counter_4bit(
	input wire clk,
	input wire en,
	output reg [3:0] count
);always @(posedge clk) begin
	if (en) begin
		count <= count + 1;
	end
end
endmodule