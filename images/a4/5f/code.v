module top_module(
	input wire [12:0] first,
	input wire [12:0] second,
	output reg isFirstGreater
);reg isFirstGreater_abs;

always @*
begin
	case ({first[12], second[12]})
	'b10 : isFirstGreater = 1;
	'b01 : isFirstGreater = 0;
	'b11 : begin
		if({first[3:0],first[11:4]} > {second[3:0],second[11:4]})
			isFirstGreater = 1;
		else
			isFirstGreater = 0;
	end
	'b00 : begin
		if({first[3:0],first[11:4]} < {second[3:0],second[11:4]})
			isFirstGreater = 1;
		else
			isFirstGreater = 0;
	end
	endcase
end

endmodule