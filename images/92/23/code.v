module mux_4to1(
	input clk,
	input rst_n,
	input [1:0] sel,
	input d0,
	input d1,
	input d2,
	input d3,
	output reg y
);

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			y <= 1'b0;
		else begin
			case(sel)
				2'b00: y <= d0;
				2'b01: y <= d1;
				2'b10: y <= d2;
				2'b11: y <= d3;
				default: y <= 1'b0;
			endcase
		end
	end

endmodule