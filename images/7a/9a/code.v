module sync_gray_code_counter(
	input clk,
	output reg [2:0] q);

initial
		q = 3'b000;
		
always @(posedge clk)
	case (q)
		3'b000: q <= 3'b001;
		3'b001: q <= 3'b011;
		3'b011: q <= 3'b010;
		3'b010: q <= 3'b110;
		3'b110: q <= 3'b111;
		3'b111: q <= 3'b101;
		3'b101: q <= 3'b100;
		3'b100: q <= 3'b000;
		default: q <= 3'b000;
	endcase

endmodule