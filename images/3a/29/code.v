module alu_32bit (
    input [31:0] a,
    input [31:0] b,
    input [2:0] op,
    output reg [31:0] result,
    output reg zero
);
    always @(*) begin
        case (op)
            3'b000: result = a + b;      // Addition
            3'b001: result = a - b;      // Subtraction
            3'b010: result = a & b;      // Bitwise AND
            3'b011: result = a | b;      // Bitwise OR
            3'b100: result = a ^ b;      // Bitwise XOR
            default: result = 32'b0;      // Default case
        endcase
        zero = (result == 32'b0);
    end
endmodule