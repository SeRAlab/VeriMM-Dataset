module top_module(
        
        input clk,
        input reset,
        
        input [1:0] MEM_WB,
        input [31:0] MEM_ALUout,
        input [31:0] MEM_MEMout,
        input [4:0] MEM_rd_or_rt,
        
        output reg [1:0] WB_WB,
        output reg [31:0] WB_ALUout,
        output reg [31:0] WB_MEMout,
        output reg [4:0] WB_rd_or_rt
    );always @(posedge clk)
    if(reset)
    begin
        WB_WB<=0;
        WB_ALUout<=0;
        WB_MEMout<=0;
        WB_rd_or_rt<=0;
    end
    else
    begin
        WB_WB<=MEM_WB;
        WB_ALUout<=MEM_ALUout;
        WB_MEMout<=MEM_MEMout;
        WB_rd_or_rt<=MEM_rd_or_rt;
    end
endmodule