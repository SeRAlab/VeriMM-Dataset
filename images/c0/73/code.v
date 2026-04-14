module MEMWB_Stage(
    input  clock,
    input  reset,
    input  M_Flush,
    input  M_Stall,
    input  WB_Stall,
    input  M_RegWrite,
    input  M_MemtoReg,
    input  [31:0] M_ReadData,
    input  [31:0] M_ALU_Result,
    input  [4:0]  M_RtRd,
    output reg WB_RegWrite,
    output reg WB_MemtoReg,
    output reg [31:0] WB_ReadData,
    output reg [31:0] WB_ALU_Result,
    output reg [4:0]  WB_RtRd
    );
    always @(posedge clock) begin
        WB_RegWrite   <= (reset) ? 0     : ((WB_Stall) ? WB_RegWrite   : ((M_Stall | M_Flush) ? 0 : M_RegWrite));
        WB_MemtoReg   <= (reset) ? 0     : ((WB_Stall) ? WB_MemtoReg                              : M_MemtoReg);
        WB_ReadData   <= (reset) ? 32'b0 : ((WB_Stall) ? WB_ReadData                              : M_ReadData);
        WB_ALU_Result <= (reset) ? 32'b0 : ((WB_Stall) ? WB_ALU_Result                            : M_ALU_Result);
        WB_RtRd       <= (reset) ? 5'b0  : ((WB_Stall) ? WB_RtRd                                  : M_RtRd);
    end
endmodule