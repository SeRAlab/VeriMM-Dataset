module pipeline_processor(
    input clk,
    input [1:0] operation, // 0 for addition, 1 for subtraction
    input [7:0] operand_a,
    input [7:0] operand_b,
    output reg [7:0] result,
    output reg valid
);
    reg [1:0] op_stage1;
    reg [7:0] a_stage1, b_stage1;

    // Stage 1: Latch inputs
    always @(posedge clk) begin
        op_stage1 <= operation;
        a_stage1 <= operand_a;
        b_stage1 <= operand_b;
    end

    // Stage 2: Perform operation
    always @(posedge clk) begin
        case (op_stage1)
            2'b00: result <= a_stage1 + b_stage1; // Addition
            2'b01: result <= a_stage1 - b_stage1; // Subtraction
            default: result <= 8'b0;
        endcase
        valid <= 1'b1; // Indicate result is valid
    end
endmodule