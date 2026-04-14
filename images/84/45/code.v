module top_module(
	input clk,
	input reset,
	input [1:0]sel,
	input [3:0]in,
	output reg out
);reg [3:0]d;

	always @(posedge clk or posedge reset)
	begin
		if (reset) d <= 0;
		else
			case (sel)
				2'b00: d <= {in[0], 3'b0};
				2'b01: d <= {in[1], 3'b0};
				2'b10: d <= {in[2], 3'b0};
				2'b11: d <= {in[3], 3'b0};
			endcase
	end

	always @(posedge clk or posedge reset)
	begin
		if (reset) out <= 0;
		else out <= d[0];
	end

endmodule