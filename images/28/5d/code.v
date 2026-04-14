module merge_sort_4way (
    input clk,
    input rst,
    input [7:0] input0,
    input [7:0] input1,
    input [7:0] input2,
    input [7:0] input3,
    output reg [7:0] output0,
    output reg [7:0] output1,
    output reg [7:0] output2,
    output reg [7:0] output3,
    output reg done
);
    reg [7:0] stage1 [0:3];
    reg [7:0] stage2 [0:3];
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            output0 <= 8'b0;
            output1 <= 8'b0;
            output2 <= 8'b0;
            output3 <= 8'b0;
            done <= 1'b0;
        end else begin
            // Stage 1: Load inputs
            stage1[0] <= input0;
            stage1[1] <= input1;
            stage1[2] <= input2;
            stage1[3] <= input3;

            // Stage 2: Merge sort logic (2-way merges)
            // First merge (0,1) and (2,3)
            stage2[0] <= (stage1[0] < stage1[1]) ? stage1[0] : stage1[1];
            stage2[1] <= (stage1[0] < stage1[1]) ? stage1[1] : stage1[0];
            stage2[2] <= (stage1[2] < stage1[3]) ? stage1[2] : stage1[3];
            stage2[3] <= (stage1[2] < stage1[3]) ? stage1[3] : stage1[2];

            // Final merge (0,2), (1,3)
            output0 <= (stage2[0] < stage2[2]) ? stage2[0] : stage2[2];
            output1 <= (stage2[0] < stage2[2]) ? stage2[2] : stage2[0];
            output2 <= (stage2[1] < stage2[3]) ? stage2[1] : stage2[3];
            output3 <= (stage2[1] < stage2[3]) ? stage2[3] : stage2[1];

            done <= 1'b1;
        end
    end
endmodule