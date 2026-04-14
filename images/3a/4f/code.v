module pipelined_processor (
    input wire clk,
    input wire reset,
    input wire [7:0] a,
    input wire [7:0] b,
    input wire op, // 0 for addition, 1 for subtraction
    output reg [7:0] result
);
    reg [7:0] stage1_result;
    reg [7:0] stage2_result;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage1_result <= 8'b0;
            stage2_result <= 8'b0;
            result <= 8'b0;
        end else begin
            // Stage 1
            if (op == 0) // Addition
                stage1_result <= a + b;
            else // Subtraction
                stage1_result <= a - b;

            // Stage 2
            stage2_result <= stage1_result + 8'd5;
            result <= stage2_result;
        end
    end
endmodule