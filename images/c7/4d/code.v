module simple_calculator(
	input [3:0] A,
	input [3:0] B,
	input op,
	output [3:0] Z
);

	always @(*) begin
		if (op == 0) begin
			Z <= A + B;
		end else begin
			Z <= A - B;
		end
	end
	
endmodule