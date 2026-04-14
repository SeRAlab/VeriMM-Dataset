module ALU (
    input [63:0] A,
    input [63:0] B,
    input [2:0] opcode,
    output reg [63:0] result,
    output reg valid
);
    always @(*) begin
        valid = 1'b1; // Operation is always valid
        case (opcode)
            3'b000: result = A + B;          // ADD
            3'b001: result = A - B;          // SUBTRACT
            3'b010: result = A & B;          // AND
            3'b011: result = A | B;          // OR
            3'b100: result = A ^ B;          // XOR
            3'b101: result = ~(A & B);       // NAND
            3'b110: result = ~(A | B);       // NOR
            3'b111: result = ~(A ^ B);       // XNOR
            default: result = 64'b0;         // Default case
        endcase
    end
endmodule