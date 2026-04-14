module pipeline_2stage (
    input clk,
    input rst,
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    output reg [3:0] sum_out,
    output reg [3:0] sub_out
);
    reg [3:0] sum_stage;

    // First pipeline stage - Addition
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sum_stage <= 4'b0000;
        end else begin
            sum_stage <= a + b;
        end
    end

    // Second pipeline stage - Subtraction
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sum_out <= 4'b0000;
            sub_out <= 4'b0000;
        end else begin
            sum_out <= sum_stage;
            sub_out <= sum_stage - c;
        end
    end
endmodule