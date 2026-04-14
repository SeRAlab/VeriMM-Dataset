module alu_32bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input [2:0] op_sel, // Operation selection signal.
    input [31:0] a,     // First 32-bit input operand.
    input [31:0] b,     // Second 32-bit input operand.

    output [31:0] result, // 32-bit result of the ALU operation.
    output zero          // Flag signal indicating whether the result is zero.
);

reg [31:0] result_r; // Result register.
reg zero_r;          // Zero flag register.

//------------------------------------------------
// ALU operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result_r <= 32'b0;
    end
    else begin
        case (op_sel)
            3'b000: result_r <= a + b;   // Addition
            3'b001: result_r <= a - b;   // Subtraction
            3'b010: result_r <= a & b;   // AND
            3'b011: result_r <= a | b;   // OR
            3'b100: result_r <= a ^ b;   // XOR
            default: result_r <= 32'b0;  // Default case
        endcase
    end
end

assign result = result_r;

//------------------------------------------------
// Zero flag generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        zero_r <= 1'b0;
    end
    else begin
        zero_r <= (result_r == 32'b0);
    end
end

assign zero = zero_r;

endmodule