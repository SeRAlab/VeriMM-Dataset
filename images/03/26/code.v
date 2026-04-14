module ALU (
    input [31:0] A,
    input [31:0] B,
    input [2:0] opcode,
    output reg [31:0] result,
    output reg Z
);
    
    always @(*) begin
        case (opcode)
            3'b000: result = A + B;          // ADD
            3'b001: result = A - B;          // SUB
            3'b010: result = A & B;          // AND
            3'b011: result = A | B;          // OR
            3'b100: result = A ^ B;          // XOR
            3'b101: result = (A < B) ? 32'b1 : 32'b0; // SLT
            3'b110: result = ~(A | B);       // NOR
            3'b111: result = ~(A & B);       // NAND
            default: result = 32'b0;         // Default case
        endcase
        Z = (result == 32'b0) ? 1'b1 : 1'b0; // Set zero flag
    end
endmodule