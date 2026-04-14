module comparator (
	input [9:0] A,
	input [9:0] B,
	output reg A_gt_B);
	
	always @(*) begin
		if (A > B)
			A_gt_B <= 1;
		else
			A_gt_B <= 0;
	end

endmodule