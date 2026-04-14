module alu_32bit(A, B, opcode, result);
    input [31:0] A;
    input [31:0] B;
    input [2:0] opcode;
    output reg [31:0] result;

    always @(*) begin
        case (opcode)
            3'b000: result = A + B;   // Addition
            3'b001: result = A - B;   // Subtraction
            3'b010: result = A & B;   // AND
            3'b011: result = A | B;   // OR
            3'b100: result = A ^ B;   // XOR
            default: result = 32'b0;  // Default case
        endcase
    end
endmodule