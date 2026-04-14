module ALU (
    input [15:0] A,
    input [15:0] B,
    input [3:0] ctrl,
    output reg [15:0] result,
    output reg zero
);
    always @(*) begin
        case (ctrl)
            4'b0000: result = A + B; // ADD
            4'b0001: result = A - B; // SUBTRACT
            4'b0010: result = A & B; // AND
            4'b0011: result = A | B; // OR
            4'b0100: result = A ^ B; // XOR
            4'b0101: result = ~(A & B); // NAND
            4'b0110: result = ~(A | B); // NOR
            4'b0111: result = ~(A ^ B); // XNOR
            4'b1000: result = (A < B) ? 16'b1 : 16'b0; // SLT
            4'b1001: result = A << 1; // SLL
            4'b1010: result = A >> 1; // SRL
            4'b1011: result = A >>> 1; // SRA
            4'b1100: result = ~A; // NOT
            4'b1101: result = A; // PASS A
            4'b1110: result = B; // PASS B
            4'b1111: result = 16'b0; // ZERO
            default: result = 16'b0; // Default case
        endcase
        zero = (result == 16'b0);
    end
endmodule