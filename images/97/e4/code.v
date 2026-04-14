module top_module(
	input [3:0] A,
	input [3:0] B,
	input [2:0] C,
	output reg [3:0] R
	);always @(*)
	begin
		if(C == 3'b000) // Addition operation
			R = A + B;
		else if(C == 3'b001) // Subtraction operation
			R = A - B;
		else
			R = 4'b0; // Invalid operation
	end

endmodule