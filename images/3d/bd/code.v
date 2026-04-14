module pipeline_7stage (
    input clk,
    input [4:0] data_in,
    output reg [4:0] data_out
);
    reg [4:0] stage_1, stage_2, stage_3, stage_4, stage_5, stage_6, stage_7;

    always @(posedge clk) begin
        stage_1 <= data_in;
        stage_2 <= stage_1;
        stage_3 <= stage_2;
        stage_4 <= stage_3;
        stage_5 <= stage_4;
        stage_6 <= stage_5;
        stage_7 <= stage_6;
    end

    always @(posedge clk) begin
        data_out <= stage_7;
    end
endmodule