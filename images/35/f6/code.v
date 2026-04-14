module pipeline_register(
    input wire clk,
    input wire [4:0] data_in,
    output reg [4:0] data_out
);
    reg [4:0] stage_0, stage_1, stage_2, stage_3, stage_4, stage_5, stage_6;

    always @(posedge clk) begin
        stage_0 <= data_in;
        stage_1 <= stage_0;
        stage_2 <= stage_1;
        stage_3 <= stage_2;
        stage_4 <= stage_3;
        stage_5 <= stage_4;
        stage_6 <= stage_5;
        data_out <= stage_6;
    end
endmodule