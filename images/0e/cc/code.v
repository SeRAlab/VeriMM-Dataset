module pipeline_register (
    input clk,
    input [7:0] instruction,
    output reg [7:0] if_stage,
    output reg [7:0] id_stage,
    output reg [7:0] ex_stage,
    output reg [7:0] mem_stage,
    output reg [7:0] wb_stage
);
    
    always @(posedge clk) begin
        if_stage <= instruction;
        id_stage <= if_stage;
        ex_stage <= id_stage;
        mem_stage <= ex_stage;
        wb_stage <= mem_stage;
    end
endmodule