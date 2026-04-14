module pipeline_processor (
    input clk,
    input rst,
    input [31:0] instruction,
    input [4:0] write_register,
    output reg [31:0] IF_stage,
    output reg [31:0] ID_stage,
    output reg [31:0] EX_stage,
    output reg [31:0] MEM_stage,
    output reg [31:0] WB_stage,
    output reg [31:0] FW_stage,
    output reg [31:0] HD_stage
);

reg [31:0] instruction_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        IF_stage <= 0;
        ID_stage <= 0;
        EX_stage <= 0;
        MEM_stage <= 0;
        WB_stage <= 0;
        FW_stage <= 0;
        HD_stage <= 0;
    end else begin
        IF_stage <= instruction;
        ID_stage <= IF_stage;
        EX_stage <= ID_stage;
        MEM_stage <= EX_stage;
        WB_stage <= MEM_stage;
        FW_stage <= WB_stage;
        HD_stage <= FW_stage;
    end
end

endmodule