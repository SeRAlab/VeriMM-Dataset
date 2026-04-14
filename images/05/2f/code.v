module ALU (
    input [15:0] A,
    input [15:0] B,
    input [3:0] opcode,
    output reg [15:0] result
);
    always @(*) begin
        case (opcode)
            4'b0000: result = A + B;         // ADD
            4'b0001: result = A - B;         // SUBTRACT
            4'b0010: result = A & B;         // AND
            4'b0011: result = A | B;         // OR
            4'b0100: result = A ^ B;         // XOR
            4'b0101: result = ~A;            // NOT (only A)
            4'b0110: result = ~(A & B);      // NAND
            4'b0111: result = ~(A | B);      // NOR
            default: result = 16'b0;         // Default case
        endcase
    end
endmodule