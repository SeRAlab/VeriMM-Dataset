module top_module(input clk, input reset, input load, input [3:0] in, output reg [3:0] out);reg [3:0] counter_reg;

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			counter_reg <= 4'b0;
		end else begin
			if (load) begin
				counter_reg <= in;
			end else begin
				counter_reg <= counter_reg + 1;
			end
		end
	end

	assign out = counter_reg;

endmodule