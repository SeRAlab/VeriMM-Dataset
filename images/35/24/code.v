module ALU (
    input [31:0] A,
    input [31:0] B,
    input [2:0] opcode,
    output reg [31:0] OUT,
    output reg Z
);
    always @(*) begin
        case (opcode)
            3'b000: OUT = A + B;                     // Addition
            3'b001: OUT = A - B;                     // Subtraction
            3'b010: OUT = A & B;                     // Bitwise AND
            3'b011: OUT = A | B;                     // Bitwise OR
            3'b100: OUT = A ^ B;                     // Bitwise XOR
            3'b101: OUT = A << 1;                    // Logical Shift Left
            3'b110: OUT = A >> 1;                    // Logical Shift Right
            3'b111: OUT = (A < B) ? 32'b1 : 32'b0;   // Set on Less Than
            default: OUT = 32'b0;                     // Default case
        endcase
        Z = (OUT == 32'b0);                           // Zero flag
    end
endmodule