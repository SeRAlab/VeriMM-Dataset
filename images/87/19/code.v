module top_module(
    input clk,
    input branch, memread,memwrite,zero,regwrite,memtoreg,
    input [15:0] aluresult,
    input [15:0] data_to_mem,
    input [3:0] regdst,
    output reg branchout, memreadout,memwriteout,zeroout,regwriteout,memtoregout,
    output reg[15:0] aluresultout,
    output reg [15:0] data_to_memout,
    output reg [3:0] regdstout    
    );always@(posedge clk) begin
     branchout <= branch;
     memreadout <= memread;
     memwriteout <= memwriteout;
     zeroout <= zero;
     regwriteout <= regwrite;
     memtoregout <= memtoreg;
     aluresultout <= aluresult;
     data_to_memout <= data_to_mem;
     regdstout <= regdst;
     
    end 
    
endmodule