module IFID_Stage(
    input  clock,
    input  reset,
    input  IF_Flush,
    input  IF_Stall,
    input  ID_Stall,
    input  [31:0] IF_Instruction,
    input  [31:0] IF_PCAdd4,
    input  [31:0] IF_PC,
    input  IF_IsBDS,
    output reg [31:0] ID_Instruction,
    output reg [31:0] ID_PCAdd4,
    output reg [31:0] ID_RestartPC,
    output reg ID_IsBDS,
    output reg ID_IsFlushed
    );
    always @(posedge clock) begin
        ID_Instruction <= (reset) ? 32'b0 : ((ID_Stall) ? ID_Instruction : ((IF_Stall | IF_Flush) ? 32'b0 : IF_Instruction));
        ID_PCAdd4      <= (reset) ? 32'b0 : ((ID_Stall) ? ID_PCAdd4                                       : IF_PCAdd4);
        ID_IsBDS       <= (reset) ? 0     : ((ID_Stall) ? ID_IsBDS                                        : IF_IsBDS);
        ID_RestartPC   <= (reset) ? 32'b0 : ((ID_Stall | IF_IsBDS) ? ID_RestartPC                         : IF_PC);
        ID_IsFlushed   <= (reset) ? 0     : ((ID_Stall) ? ID_IsFlushed                                    : IF_Flush);
    end
endmodule