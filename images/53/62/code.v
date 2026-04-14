module top_module(
	input wire clk,
	output reg reset_soft);reg [50:0] count;
	wire [50:0] count_next;

	always @(posedge clk)
	begin
		count <= count_next;
	end

	assign count_next = count + 1;

	always @(*)
		case(count)
			50'b0: reset_soft = 1;
			50'b1: reset_soft = 1;
			50'b11: reset_soft = 1;
			default: reset_soft = 0;
		endcase

endmodule