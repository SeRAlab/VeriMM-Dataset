module top_module(
	input clk,
	input enable,
	input dir,
	output [2:0] out);reg [2:0] counter;

	always @(posedge clk) begin
		if (enable) begin
			if (dir)
				counter <= counter + 1;
			else
				counter <= counter - 1;
		end
	end

	assign out = counter;

endmodule