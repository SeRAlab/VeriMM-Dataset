module top_module(
	input [3:0] dat,
	output [6:0] seg
);reg [6:0] seg_inv;
	always @* begin
		seg_inv = 0;
		case (dat)
			4'h0: seg_inv = 7'b 0111111;
			4'h1: seg_inv = 7'b 0000110;
			4'h2: seg_inv = 7'b 1011011;
			4'h3: seg_inv = 7'b 1001111;
			4'h4: seg_inv = 7'b 1100110;
			4'h5: seg_inv = 7'b 1101101;
			4'h6: seg_inv = 7'b 1111101;
			4'h7: seg_inv = 7'b 0000111;
			4'h8: seg_inv = 7'b 1111111;
			4'h9: seg_inv = 7'b 1101111;
			4'hA: seg_inv = 7'b 1110111;
			4'hB: seg_inv = 7'b 1111100;
			4'hC: seg_inv = 7'b 0111001;
			4'hD: seg_inv = 7'b 1011110;
			4'hE: seg_inv = 7'b 1111001;
			4'hF: seg_inv = 7'b 1110001;
		endcase
	end
	assign seg = ~seg_inv;
endmodule