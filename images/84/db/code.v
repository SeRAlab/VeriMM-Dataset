module top_module(dividend, divisor, clk, resetn, quotient, done);input [31:0] dividend;
input [31:0] divisor;
input clk;
input resetn;
output reg [31:0] quotient;
output reg done;

reg [31:0] remainder;
reg sign;
integer i; // Declare the integer variable i

always @ (posedge clk) begin
	if (resetn == 0) begin
		quotient <= 32'b0;
		remainder <= 32'b0;
		sign <= 0;
		done <= 0;
	end else begin
		if (divisor == 0) begin
			quotient <= 32'b0;
			done <= 1;
		end else begin
			if (dividend[31] == 1 && divisor[31] == 0) begin
				sign <= 1;
			end else if (dividend[31] == 0 && divisor[31] == 1) begin
				sign <= 1;
			end else begin
				sign <= 0;
			end
			remainder <= dividend;
			quotient <= 32'b0;
			for (i = 0; i < 32; i = i + 1) begin
				quotient = quotient << 1;
				if (remainder >= divisor) begin // Change condition to check if remainder can subtract divisor
					remainder = remainder - divisor;
					quotient[0] = 1; // Update the least significant bit of quotient
				end else begin
					quotient[0] = 0;
				end
				remainder = remainder << 1; // Shift remainder left
			end
			if (sign == 1) begin
				quotient = ~quotient + 1;
			end
			done <= 1;
		end
	end
end

endmodule