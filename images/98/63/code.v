module top_module(
	input [12:0] A, B, 
	output reg [12:0] Max, Min
);wire [8:0] temp;
	assign temp = {1'b0, A[12:5]} - {1'b0, B[12:5]};
	
	always @(*) begin
		if (temp[8] == 1'b1) begin
			Max = B;
			Min = A;
		end
		else begin
			Max = A;
			Min = B;
		end
	end

endmodule