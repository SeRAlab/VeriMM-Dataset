module top_module(
    input clk, rst,
    input EX_RegWrite, EX_MemtoReg, EX_MemWrite,
    input [2:0] EX_JumpBranch,
    input [31:0] EX_ALUorNPC, EX_wmData,
    input [4:0] EX_rtAddr, EX_wrAddr,
    output reg MEM_RegWrite, MEM_MemtoReg, MEM_MemWrite,
    output reg [2:0] MEM_JumpBranch,
    output reg [31:0] MEM_ALUorNPC, MEM_wmData,
    output reg [4:0] MEM_rtAddr, MEM_wrAddr
    );always@ (posedge clk,posedge rst)
        if(rst)
            begin
                MEM_RegWrite <= 0;
                MEM_MemWrite <= 0;
            end
        else
            begin
                MEM_RegWrite <= EX_RegWrite;
                MEM_MemtoReg <= EX_MemtoReg;
                MEM_MemWrite <= EX_MemWrite;
                MEM_JumpBranch <= EX_JumpBranch;
                MEM_ALUorNPC <= EX_ALUorNPC;
                MEM_wmData <= EX_wmData;
                MEM_rtAddr <= EX_rtAddr;
                MEM_wrAddr <= EX_wrAddr;
            end    
    
endmodule