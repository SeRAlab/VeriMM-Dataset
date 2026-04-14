module debouncer(
	input                clk,
	input                reset,
	input                noisy_in,
	output reg           clean_out
);

reg [2:0] shift_reg1, shift_reg2;

always @(posedge clk)
begin
	if (reset)
	begin
		shift_reg1 <= 3'b000;
		shift_reg2 <= 3'b000;
		clean_out <= 0;
	end
	else
	begin
		shift_reg1 <= {shift_reg1[1:0], noisy_in};
		shift_reg2 <= {shift_reg2[1:0], shift_reg1[2]};
		clean_out <= shift_reg2[2];
	end
end

endmodule