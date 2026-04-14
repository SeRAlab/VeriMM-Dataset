module top_module(
	input [1:0] RegSrc,
	input [15:0] readFromMem,
	input [15:0] ALUResult,
	input [15:0] op2Val,
	output reg [15:0] outRegSrc
);always@(*) begin
	if (RegSrc == 2'b00 || RegSrc == 2'b01) begin
		outRegSrc = readFromMem;
	end
	else if (RegSrc == 2'b10) begin
		outRegSrc = ALUResult;
	end
	else begin
		outRegSrc = op2Val;
	end
end

endmodule