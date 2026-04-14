module ALU (
    input [15:0] a,
    input [15:0] b,
    input [3:0] opcode,
    output reg [15:0] result,
    output reg carry
);

always @(*) begin
    carry = 0;
    case (opcode)
        4'b0000: {carry, result} = a + b;                // Addition
        4'b0001: {carry, result} = a - b;                // Subtraction
        4'b0010: result = a & b;                          // AND
        4'b0011: result = a | b;                          // OR
        4'b0100: result = a ^ b;                          // XOR
        4'b0101: result = a << 1;                         // Shift Left
        4'b0110: result = a >> 1;                         // Shift Right
        default: result = 16'b0;                          // Default case
    endcase
end
endmodule