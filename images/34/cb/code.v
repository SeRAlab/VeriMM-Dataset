module two_stage_pipeline (
    input clk,
    input rst,
    input [4:0] data_in,
    output reg [4:0] data_out
);
    reg [4:0] stage1_out;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1_out <= 5'b00000;
            data_out <= 5'b00000;
        end else begin
            // Stage 1: Bitwise NOT operation
            stage1_out <= ~data_in;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 5'b00000;
        end else begin
            // Stage 2: Bitwise AND with 5'b10101
            data_out <= stage1_out & 5'b10101;
        end
    end
endmodule