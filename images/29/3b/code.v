module ALU (
    input [31:0] A,
    input [31:0] B,
    input [3:0] opcode,
    output reg [31:0] result,
    output reg Z
);
    always @(*) begin
        case (opcode)
            4'b0000: result = A & B;         // AND
            4'b0001: result = A | B;         // OR
            4'b0010: result = A ^ B;         // XOR
            4'b0011: result = A + B;         // ADD
            4'b0100: result = A - B;         // SUB
            4'b0101: result = (A < B) ? 32'b1 : 32'b0; // SLT
            4'b0110: result = ~(A & B);      // NAND
            4'b0111: result = ~(A | B);      // NOR
            4'b1000: result = ~(A ^ B);      // XNOR
            4'b1001: result = A >>> 1;       // SRA
            4'b1010: result = A << 1;        // SLL
            4'b1011: result = A >> 1;        // SRL
            4'b1100: result = ~A;             // NOT
            4'b1101: result = A;              // PASS A
            4'b1110: result = B;              // PASS B
            4'b1111: result = 32'b0;          // NOP
            default: result = 32'b0;          // Default case
        endcase
        Z = (result == 32'b0) ? 1'b1 : 1'b0; // Set zero flag
    end
endmodule