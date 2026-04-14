module top_module(
    input clk, reset,
    input ZERO_EX,
    input [31:0] ALU_OUT_EX,
    input [31:0] PC_Branch_EX,
    input [31:0] REG_DATA2_EX_FINAL,
    input [1:0] WB_EX,
    input [2:0] M_EX,
    input [4:0] RD_EX,
    output reg ZERO_MEM,
    output reg[31:0] ALU_OUT_MEM,
    output reg[31:0] PC_Branch_MEM,
    output reg[31:0] REG_DATA2_MEM_FINAL,
    output reg [1:0] WB_MEM,
    output reg [2:0] M_MEM,
    output reg [4:0] RD_MEM
    );always@(posedge clk) begin
    if (reset) begin
        ZERO_MEM = 0;
        ALU_OUT_MEM = 0;
        PC_Branch_MEM = 0;
        REG_DATA2_MEM_FINAL = 0;
        WB_MEM = 0;
        M_MEM = 0;
        RD_MEM = 0;
    end
    else begin
      
        ZERO_MEM <= ZERO_EX;
        ALU_OUT_MEM <= ALU_OUT_EX;
        PC_Branch_MEM <= PC_Branch_EX;
        REG_DATA2_MEM_FINAL <= REG_DATA2_EX_FINAL;
        WB_MEM <= WB_EX;
        M_MEM <= M_EX;
        RD_MEM <= RD_EX;
    end
  end
endmodule