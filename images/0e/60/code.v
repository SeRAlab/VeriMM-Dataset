module pipeline_adder (
    input clk,
    input rst,
    input [31:0] in_a,
    input [31:0] in_b,
    output reg [31:0] out_sum
);
    reg [31:0] stage1, stage2, stage3, stage4, stage5, stage6, stage7;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1 <= 0;
            stage2 <= 0;
            stage3 <= 0;
            stage4 <= 0;
            stage5 <= 0;
            stage6 <= 0;
            stage7 <= 0;
            out_sum <= 0;
        end else begin
            stage1 <= in_a + in_b;          // Execute
            stage2 <= stage1;               // Intermediate stage
            stage3 <= stage2;               // Intermediate stage
            stage4 <= stage3;               // Intermediate stage
            stage5 <= stage4;               // Intermediate stage
            stage6 <= stage5;               // Intermediate stage
            stage7 <= stage6;               // Write back
            out_sum <= stage7;              // Output
        end
    end
endmodule