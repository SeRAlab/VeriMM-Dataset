module ALU_64bit (
    input [63:0] A,        // First operand
    input [63:0] B,        // Second operand
    input [2:0] ALU_op,    // Operation code
    output reg [63:0] result, // Result of the operation
    output reg zero       // Zero flag
);

always @(*) begin
    case (ALU_op)
        3'b000: result = A + B;        // Addition
        3'b001: result = A - B;        // Subtraction
        3'b010: result = A & B;        // Bitwise AND
        3'b011: result = A | B;        // Bitwise OR
        3'b100: result = A ^ B;        // Bitwise XOR
        default: result = 64'b0;        // Default case
    endcase
    
    zero = (result == 64'b0);         // Set zero flag
end

endmodule