module top_module(input wire [2:0] alufun, input wire [31:0] inst, input [1:0] op2sel, input wire [4:0] rs1, input wire [31:0] rs2, output reg [31:0] result);always @(inst) begin

	if (op2sel == 1) begin
		if (alufun == 3'b000) begin
			result <= rs1 + rs2;
			
		end

		else begin
			result <= rs2;
		end
	end

	if (op2sel == 3) begin
		if (alufun == 3'b000) begin
			result <= rs1 + rs2;
		end

		if(alufun == 1'h1) begin
			result <= rs1 << rs2;
		end
	end

end

endmodule