module top_module(
    input  clock,
    input  reset,
    input  IF_Flush,
    input  IF_Stall,
    input  ID_Stall,
    
    input  [31:0] IF_Instruction,
    
    input  [31:0] IF_PCAdd4,
    input  [31:0] IF_PC,
    input  IF_IsBDS,
    
	 input [31:0] ID_Instruction,
    input [31:0] ID_PCAdd4,
    input [31:0] ID_RestartPC,
    input ID_IsBDS,
    input ID_IsFlushed,
    output reg [31:0] vote_ID_Instruction,
    output reg [31:0] vote_ID_PCAdd4,
    output reg [31:0] vote_ID_RestartPC,
    output reg vote_ID_IsBDS,
    output reg vote_ID_IsFlushed
    );always @(posedge clock) begin
        vote_ID_Instruction <= (reset) ? 32'b0 : ((ID_Stall) ? ID_Instruction : ((IF_Stall | IF_Flush) ? 32'b0 : IF_Instruction));
        vote_ID_PCAdd4      <= (reset) ? 32'b0 : ((ID_Stall) ? ID_PCAdd4                                       : IF_PCAdd4);
        vote_ID_IsBDS       <= (reset) ? 1'b0  : ((ID_Stall) ? ID_IsBDS                                        : IF_IsBDS);
        vote_ID_RestartPC   <= (reset) ? 32'b0 : ((ID_Stall | IF_IsBDS) ? ID_RestartPC                         : IF_PC);
        vote_ID_IsFlushed   <= (reset) ? 1'b0  : ((ID_Stall) ? ID_IsFlushed                                    : IF_Flush);
    end

endmodule