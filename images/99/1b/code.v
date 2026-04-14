module top_module(
				input wire clk, rst, 
				input wire branch, 
				input wire jump, 
				input wire MemRead, 
				input wire MemWrite, 
				input wire RegWrite, 
				input wire MemtoReg, 
				input wire [31:0] alu,
				input wire [31:0] readdata2, 
				input wire [4:0] mux,

				output reg branch_out,
				output reg jump_out,
				output reg MemRead_out,
				output reg MemWrite_out,
				output reg RegWrite_out,
				output reg MemtoReg_out,
				output reg [31:0] alu_out,
				output reg [31:0] readdata2_out, 
				output reg [4:0] mux_out
			);always @(posedge rst)
begin
	branch_out <= 0;
	jump_out <= 0;
	MemRead_out <= 0;
	MemWrite_out <= 0;
	RegWrite_out <= 0;
	MemtoReg_out <= 0;
	alu_out <= 0;
	readdata2_out <= 0; 
	mux_out <= 0;
end

always @(posedge clk) 
begin
	branch_out <= branch;
	jump_out <= jump;
	MemRead_out <= MemRead;
	MemWrite_out <= MemWrite;
	RegWrite_out <= RegWrite;
	MemtoReg_out <= MemtoReg;
	alu_out <= alu;
	readdata2_out <= readdata2;
	mux_out <= mux;
end

endmodule