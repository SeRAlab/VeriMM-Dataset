module clock_enable_generator(
	input clk,
	input reset_n,
	output reg enable);reg [2:0] count;

always @(posedge clk or negedge reset_n) begin
	if (!reset_n) begin
		count <= 3'b000;
		enable <= 0;
	end else if (count == 3'b100) begin
		count <= 3'b000;
		enable <= 1;
	end else begin
		count <= count + 1;
		enable <= 0;
	end
end

endmodule