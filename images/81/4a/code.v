module barrel_shifter(
	input [5:0] data,
	input [2:0] shift_amount,
	input direction,
	output reg [5:0] out);
always @* begin
	if (direction) // Right shift
		out = data >> shift_amount;
	else // Left shift
		out = data << shift_amount;
end

endmodule