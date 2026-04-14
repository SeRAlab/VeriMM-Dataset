module ALU_16bit(
    input [15:0] A, // First operand
    input [15:0] B, // Second operand
    input [2:0] opcode, // Operation code
    output reg [15:0] result // Result of the operation
);
    always @(*) begin
        case (opcode)
            3'b000: result = A + B;          // ADD
            3'b001: result = A - B;          // SUBTRACT
            3'b010: result = A & B;          // AND
            3'b011: result = A | B;          // OR
            3'b100: result = A ^ B;          // XOR
            default: result = 16'b0000000000000000; // Default case
        endcase
    end
endmodule