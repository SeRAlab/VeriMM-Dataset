module pipeline_arithmetic (
    input wire clk,
    input wire reset,
    input wire [7:0] a,
    input wire [7:0] b,
    input wire op, // 0 for addition, 1 for subtraction
    output reg [7:0] result
);
    reg [7:0] stage1_a, stage1_b;
    reg [7:0] stage2_result;
    reg [2:0] stage3; // operation type
    reg [7:0] stage4_result;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage1_a <= 0;
            stage1_b <= 0;
            stage2_result <= 0;
            stage3 <= 0;
            stage4_result <= 0;
            result <= 0;
        end else begin
            // Stage 1: Read inputs
            stage1_a <= a;
            stage1_b <= b;
            // Stage 2: Prepare for operation
            stage2_result <= (op == 0) ? (stage1_a + stage1_b) : (stage1_a - stage1_b);
            // Stage 3: Store operation type
            stage3 <= op;
            // Stage 4: Final result
            stage4_result <= stage2_result;
            // Stage 5: Output the result
            result <= stage4_result;
        end
    end
endmodule