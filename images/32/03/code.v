module pipeline_processor (
    input clk,
    input reset,
    input [3:0] in_data,
    output reg [3:0] out_data
);
    reg [3:0] stage1_result;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage1_result <= 4'b0000;
            out_data <= 4'b0000;
        end else begin
            // Stage 1: Add 1
            stage1_result <= in_data + 1;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out_data <= 4'b0000;
        end else begin
            // Stage 2: Subtract 2
            out_data <= stage1_result - 2;
        end
    end
endmodule