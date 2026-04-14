module instruction_pipeline (
    input clk,
    input reset,
    input [31:0] instruction, // 32-bit instruction
    output reg [31:0] result // Result after execution
);

    reg [31:0] instruction_reg; // Register for instruction
    reg [31:0] operand1, operand2; // Operands
    reg [3:0] operation; // Operation code

    // IF stage
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            instruction_reg <= 0;
        end else begin
            instruction_reg <= instruction; // Fetch instruction
        end
    end

    // ID stage
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            operand1 <= 0;
            operand2 <= 0;
            operation <= 0;
        end else begin
            // Decode instruction (assuming the instruction format is well-defined)
            operand1 <= instruction_reg[15:0]; // First operand from instruction
            operand2 <= instruction_reg[31:16]; // Second operand from instruction
            operation <= instruction_reg[30:28]; // Operation code
        end
    end

    // EX stage
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            result <= 0;
        end else begin
            case (operation)
                4'b0000: result <= operand1 + operand2; // Addition
                4'b0001: result <= operand1 - operand2; // Subtraction
                4'b0010: result <= operand1 * operand2; // Multiplication
                4'b0011: result <= operand1 / operand2; // Division
                default: result <= 0;
            endcase
        end
    end
endmodule