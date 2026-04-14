module top_module(
    input clk,
    input reset,
    input [63:0] ReadDatain,
    input [63:0] ALU_Resultin,
    input MemtoReg, RegWrite,
    input [4:0] rd,
    output reg [63:0] ReadDataout,
    output reg [63:0] ALU_Resultout,
    output reg [4:0] rdOut,
    output reg MemtoRegOut, RegWriteOut
);always @(posedge clk)
begin
    if (reset==1'b0)
    begin
    ReadDataout=ReadDatain;
    ALU_Resultout=ALU_Resultin;
    rdOut=rd;
    MemtoRegOut=MemtoReg;
    RegWriteOut=RegWrite;
    end
end
always@(reset)
begin
    if (reset==1'b1)
    begin
    ReadDataout=64'b0;
    ALU_Resultout=64'b0;
    rdOut=5'b0;
    MemtoRegOut=1'b0;
    RegWriteOut=1'b0;
    
    end
end
endmodule