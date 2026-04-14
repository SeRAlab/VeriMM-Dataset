module ALU (
    input [63:0] A,
    input [63:0] B,
    input [2:0] ALUOp,
    output reg [63:0] result
);
    always @(*) begin
        case (ALUOp)
            3'b000: result = A + B;                   // Addition
            3'b001: result = A - B;                   // Subtraction
            3'b010: result = A & B;                   // Bitwise AND
            3'b011: result = A | B;                   // Bitwise OR
            3'b100: result = A ^ B;                   // Bitwise XOR
            3'b101: result = A << 1;                  // Left Shift
            3'b110: result = A >> 1;                  // Right Shift
            3'b111: result = (A < B) ? 64'b1 : 64'b0; // Set on Less Than
            default: result = 64'b0;                  // Default case
        endcase
    end
endmodule