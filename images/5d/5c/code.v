module top_module(
	funct_i,
	aluop_i,
	aluctrl_o
);input 	[5:0] 	funct_i;
input 	[1:0] 	aluop_i;
output 	[2:0] 	aluctrl_o;

reg 	[2:0] 	temp_aluctrl_o;
assign aluctrl_o = temp_aluctrl_o;

always @ (funct_i or aluop_i)
begin
	if (aluop_i == 2'b00)
		temp_aluctrl_o = 3'b001;
	else
		case (funct_i)
			6'b100000: temp_aluctrl_o = 3'b001;
			6'b100010: temp_aluctrl_o = 3'b010;
			6'b100100: temp_aluctrl_o = 3'b011;
			6'b100101: temp_aluctrl_o = 3'b100;
			6'b011000: temp_aluctrl_o = 3'b101;
			default: temp_aluctrl_o = 3'b000;
		endcase
end
					

endmodule