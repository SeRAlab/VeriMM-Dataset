module top_module(
    input wire clock,

    
    
    input wire [31:0] MEM_instruction,
    output reg [31:0] WB_instruction,

    input wire [31:0] MemReadData,
    output reg [31:0] WB_MemReadData,
    input wire [31:0] MEM_ALUResult,
    output reg [31:0] WB_ALUResult,
    input wire [4:0] MEM_RegWriteAddress,
    output reg [4:0] WB_RegWriteAddress,

    input wire MEM_RegWrite,
    output reg WB_RegWrite,
    input wire MEM_MemToReg,
    output reg WB_MemToReg
    );always @(negedge clock) begin
        
        
        WB_instruction <= MEM_instruction;

        WB_MemReadData <= MemReadData;
        WB_ALUResult <= MEM_ALUResult;
        WB_RegWriteAddress <= MEM_RegWriteAddress;

        WB_RegWrite <= MEM_RegWrite;
        WB_MemToReg <= MEM_MemToReg;
    end  
endmodule