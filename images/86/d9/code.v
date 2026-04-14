module top_module(output reg [3:0] count, output reg carry_out, input enable_l, clk_l, reset, load, input [3:0] data);always @(negedge clk_l)
		if (reset) count <= 0;
		else if (load) count <= data;
		else if (!enable_l) count <= count + 1;

	always @(count)
		if (count == 'b1111) carry_out <= 1;
		else carry_out <= 0;
endmodule