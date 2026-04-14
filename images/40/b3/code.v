module ALU (
    input [31:0] A,
    input [31:0] B,
    input [2:0] ALUOp,
    output reg [31:0] Result,
    output reg Zero
);
    always @(*) begin
        case (ALUOp)
            3'b000: Result = A + B;        // ADD
            3'b001: Result = A - B;        // SUB
            3'b010: Result = A & B;        // AND
            3'b011: Result = A | B;        // OR
            3'b100: Result = A ^ B;        // XOR
            3'b101: Result = ~(A & B);     // NAND
            3'b110: Result = ~(A | B);     // NOR
            3'b111: Result = ~(A ^ B);     // XNOR
            default: Result = 32'h00000000; // Default case
        endcase
        Zero = (Result == 32'h00000000) ? 1'b1 : 1'b0; // Set Zero flag
    end
endmodule