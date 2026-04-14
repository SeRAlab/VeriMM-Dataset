module alu_8bit (
    input [7:0] A,
    input [7:0] B,
    input [2:0] opcode,
    output reg [7:0] R,
    output reg Z
);
    always @(*) begin
        case (opcode)
            3'b000: R = A + B; // Addition
            3'b001: R = A - B; // Subtraction
            3'b010: R = A & B; // AND
            3'b011: R = A | B; // OR
            3'b100: R = A ^ B; // XOR
            3'b101: R = ~(A | B); // NOR
            3'b110: R = ~(A & B); // NAND
            3'b111: R = (A < B) ? 8'b00000001 : 8'b00000000; // A < B comparison
            default: R = 8'b00000000; // Default case
        endcase
        Z = (R == 8'b00000000) ? 1'b1 : 1'b0; // Zero flag
    end
endmodule