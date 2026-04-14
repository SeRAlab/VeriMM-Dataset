module up_counter_4bit(clk, rst, en, count);

	// I/O declarations
	input clk, rst, en;
	output reg [3:0] count;

	// Counter logic
	always @(posedge clk) begin
		if (rst) begin
			count <= 4'b0000;
		end else if (en) begin
			count <= count + 1;
		end
	end

endmodule