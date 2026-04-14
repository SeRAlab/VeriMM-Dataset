module top_module(
	output reg [31:0] instruction,
	input [31:0] readAddress
);reg [7:0] mips_instruction_memory [55:0];

always @(*) begin
	instruction[7:0] = mips_instruction_memory[readAddress[31:0] + 32'b11];
	instruction[15:8] = mips_instruction_memory[readAddress[31:0] + 32'b10];
	instruction[23:16] = mips_instruction_memory[readAddress[31:0] + 32'b01];
	instruction[31:24] = mips_instruction_memory[readAddress[31:0]];
end


endmodule