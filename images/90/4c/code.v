module top_module(
	output [3:0] ALUCtrl,
	input  [3:0] ALUop,
	input  [5:0] FuncCode
);reg [3:0] out;

always @ (ALUop, FuncCode) begin
	if (ALUop == 4'b1111) 
		case (FuncCode)
			
			
			6'b100100: out <= 4'b0000;

			
			6'b100101: out <= 4'b0001;

			
			6'b100000: out <= 4'b0010;

			
			6'b000000: out <= 4'b0011;

			
			6'b000010: out <= 4'b0100;

			
			6'b100010: out <= 4'b0110;

			
			6'b101010: out <= 4'b0111;

			
			6'b100001: out <= 4'b1000;

			
			6'b100011: out <= 4'b1001;

			
			6'b100110: out <= 4'b1010;

			
			6'b101011: out <= 4'b1011;

			
			6'b100111: out <= 4'b1100;

			
			6'b000011: out <= 4'b1101;

		endcase

	else out <= ALUop;
end

 assign #2 ALUCtrl = out;

endmodule