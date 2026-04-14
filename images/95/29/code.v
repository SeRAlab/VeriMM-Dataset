module top_module(
    input wire clock,

    
    
    input wire [31:0] EX_instruction,
    output reg [31:0] MEM_instruction,

    input wire [31:0] branch_address,
    output reg [31:0] MEM_branch_address,
    input wire Zero,
    output reg MEM_Zero,
    input wire [31:0] ALUResult,
    output reg [31:0] MEM_ALUResult,
    input wire [31:0] ForwardBOut,
    output reg [31:0] MEM_ForwardBOut,
    input wire [4:0] RegWriteAddress,
    output reg [4:0] MEM_RegWriteAddress,

    input wire EX_RegWrite,
    output reg MEM_RegWrite,
    input wire EX_MemRead,
    output reg MEM_MemRead,
    input wire EX_MemWrite,
    output reg MEM_MemWrite,
    input wire EX_MemToReg,
    output reg MEM_MemToReg,
    input wire EX_Branch,
    output reg MEM_Branch,
    input wire bneOne,
    output reg MEM_bneOne
    );always @(negedge clock) begin
        
        
        MEM_instruction <= EX_instruction;

        MEM_branch_address <= branch_address;
        MEM_Zero <= Zero;
        MEM_ALUResult <= ALUResult;
        MEM_ForwardBOut <= ForwardBOut;
        MEM_RegWriteAddress <= RegWriteAddress;

        MEM_RegWrite <= EX_RegWrite;
        MEM_MemRead <= EX_MemRead;
        MEM_MemWrite <= EX_MemWrite;
        MEM_MemToReg <= EX_MemToReg;
        MEM_Branch <= EX_Branch;
        MEM_bneOne <= bneOne;
    end  
endmodule