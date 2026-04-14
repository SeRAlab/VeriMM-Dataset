module top_module(Instruction, PCAddResult, JumpAddress);input [27:0] Instruction;
input [31:0] PCAddResult;

output reg [31:0] JumpAddress;

always @(Instruction, PCAddResult) begin
     
	JumpAddress = { PCAddResult[31:28], Instruction};
end

endmodule