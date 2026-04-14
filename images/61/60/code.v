module top_module(input clk, input reset, input enable, input in, output reg [3:0] count);reg [1:0] delay_counter;
	reg [3:0] counter;

	always @(posedge clk) begin
		if (reset) begin
			counter <= 0;
			delay_counter <= 0;
		end
		else begin
			if (enable) begin
				if (delay_counter == 2'b11) begin
					counter <= counter + 1;
				end
				delay_counter <= delay_counter + 1;
			end
			if (in) begin
				counter <= 0;
				delay_counter <= 0;
			end
		end
	end

	assign count = counter;

endmodule