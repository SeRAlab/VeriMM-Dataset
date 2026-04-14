module top_module(
	input [15:0] din,
	output reg [15:0] dout
);always @* begin
		case (1'b1)
			din[15:0] == 16'h 9999:
				dout = 0;
			din[11:0] == 12'h 999:
				dout = {din[15:12] + 4'd 1, 12'h 000};
			din[7:0] == 8'h 99:
				dout = {din[15:12], din[11:8] + 4'd 1, 8'h 00};
			din[3:0] == 4'h 9:
				dout = {din[15:8], din[7:4] + 4'd 1, 4'h 0};
			default:
				dout = {din[15:4], din[3:0] + 4'd 1};
		endcase
	end
endmodule