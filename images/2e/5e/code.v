module pipeline_7_stage (
    input clk,
    input rst,
    input [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] stage_1, stage_2, stage_3, stage_4, stage_5, stage_6, stage_7;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage_1 <= 8'b0;
            stage_2 <= 8'b0;
            stage_3 <= 8'b0;
            stage_4 <= 8'b0;
            stage_5 <= 8'b0;
            stage_6 <= 8'b0;
            stage_7 <= 8'b0;
            data_out <= 8'b0;
        end else begin
            stage_1 <= data_in;
            stage_2 <= stage_1;
            stage_3 <= stage_2;
            stage_4 <= stage_3;
            stage_5 <= stage_4;
            stage_6 <= stage_5;
            stage_7 <= stage_6;
            data_out <= stage_7;
        end
    end
endmodule