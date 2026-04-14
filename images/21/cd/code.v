module pipeline_2stage (
    input clk,
    input rst,
    input [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] stage1_out;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1_out <= 8'b0;
            data_out <= 8'b0;
        end else begin
            stage1_out <= data_in * 2; // Stage 1: Multiply by 2
            data_out <= stage1_out + 3; // Stage 2: Add 3
        end
    end
endmodule