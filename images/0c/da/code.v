module pipeline_stage (
    input wire clk,
    input wire rst,
    input wire data_in,
    output reg data_out
);
    reg stage1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1 <= 0;
            data_out <= 0;
        end else begin
            stage1 <= data_in; // Stage 1
            data_out <= stage1; // Stage 2
        end
    end
endmodule