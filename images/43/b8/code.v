module top_module(
    input [3:0] A,
    input [3:0] B,
    input [2:0] OP,
    output reg [3:0] Y
);always @(*) begin
    case(OP)
        3'b000: Y = A + B; // Addition
        3'b001: Y = A - B; // Subtraction
        3'b010: Y = A & B; // Bitwise AND
        3'b011: Y = A | B; // Bitwise OR
        3'b100: Y = A ^ B; // Bitwise XOR
        default: Y = 4'bXXXX; // Invalid operation
    endcase
end

endmodule