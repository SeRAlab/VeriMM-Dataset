module top_module(
    input clk,
    input rst,

    input MEM_RegWrite,
    input[4:0] MEM_WriteReg,
    input[1:0] MEM_RegSrc,
    input[31:0] MEM_aluResult,
    input[31:0] MEM_dmOut,
    input[31:0] MEM_PC,

    output reg WB_RegWrite,
    output reg[4:0] WB_WriteReg,
    output reg[1:0] WB_RegSrc,
    output reg[31:0] WB_aluResult,
    output reg[31:0] WB_dmOut,
    output reg[31:0] WB_PC
);always @(posedge clk) 
    begin
        WB_RegWrite <= rst ? 1'b0 : MEM_RegWrite;
        WB_WriteReg <= rst ? 5'b0 : MEM_WriteReg;
        WB_RegSrc <= rst ? 2'b0 : MEM_RegSrc;
        WB_aluResult <= rst ? 32'b0 : MEM_aluResult;
        WB_dmOut <= rst ? 32'b0 : MEM_dmOut;
        WB_PC <= rst ? 32'b0 : MEM_PC;
    end

endmodule