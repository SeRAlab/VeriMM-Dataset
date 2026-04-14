module pipeline_processor (
    input clk,
    input rst,
    input [31:0] instruction_in,
    output reg [31:0] write_data
);

    reg [31:0] stage_IF, stage_ID, stage_EX, stage_MEM, stage_WB;
    reg [31:0] stage_HD, stage_DF;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage_IF <= 32'b0;
            stage_ID <= 32'b0;
            stage_EX <= 32'b0;
            stage_MEM <= 32'b0;
            stage_WB <= 32'b0;
            stage_HD <= 32'b0;
            stage_DF <= 32'b0;
            write_data <= 32'b0;
        end else begin
            // Pipeline stages
            stage_IF <= instruction_in;
            stage_ID <= stage_IF;
            stage_EX <= stage_ID;
            stage_MEM <= stage_EX;
            stage_WB <= stage_MEM;
            stage_HD <= stage_WB;
            stage_DF <= stage_HD;
            write_data <= stage_DF; // Output write data
        end
    end
endmodule