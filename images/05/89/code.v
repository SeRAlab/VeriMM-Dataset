module ALU (
    input [31:0] A,
    input [31:0] B,
    input [2:0] opcode,
    output reg [31:0] R,
    output reg zero
);
    always @(*) begin
        case (opcode)
            3'b000: R = A + B; // Addition
            3'b001: R = A - B; // Subtraction
            3'b010: R = A & B; // Bitwise AND
            3'b011: R = A | B; // Bitwise OR
            3'b100: R = A ^ B; // Bitwise XOR
            3'b101: R = (A < B) ? 32'b1 : 32'b0; // Set on Less Than
            default: R = 32'b0; // Default case
        endcase
        zero = (R == 32'b0) ? 1'b1 : 1'b0; // Set zero flag
    end
endmodule