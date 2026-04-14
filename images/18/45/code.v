module alu_8bit (
    input [7:0] a,
    input [7:0] b,
    input [2:0] opcode,
    output reg [7:0] result,
    output reg carry
);
    always @(*) begin
        carry = 0; // Default carry
        case (opcode)
            3'b000: {carry, result} = a + b;      // Addition
            3'b001: {carry, result} = a - b;      // Subtraction
            3'b010: result = a & b;                // AND
            3'b011: result = a | b;                // OR
            3'b100: result = a ^ b;                // XOR
            default: result = 8'b00000000;         // Default case
        endcase
    end
endmodule