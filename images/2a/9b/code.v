module ALU (
    input [31:0] A,
    input [31:0] B,
    input [2:0] opcode,
    output reg [31:0] result,
    output reg Z
);
    always @(*) begin
        case (opcode)
            3'b000: result = A + B;         // Addition
            3'b001: result = A - B;         // Subtraction
            3'b010: result = A & B;         // Bitwise AND
            3'b011: result = A | B;         // Bitwise OR
            3'b100: result = A ^ B;         // Bitwise XOR
            default: result = 32'b0;        // Default case
        endcase
        Z = (result == 32'b0) ? 1'b1 : 1'b0; // Set Z flag if result is zero
    end
endmodule