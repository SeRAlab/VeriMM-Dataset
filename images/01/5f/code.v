module ALU (
    input [63:0] A,
    input [63:0] B,
    input [2:0] opcode,
    output reg [63:0] result,
    output reg zero_flag
);
    always @(*) begin
        case (opcode)
            3'b000: result = A + B; // ADD
            3'b001: result = A - B; // SUB
            3'b010: result = A & B; // AND
            3'b011: result = A | B; // OR
            3'b100: result = A ^ B; // XOR
            3'b101: result = ~A;     // NOT
            3'b110: result = ~(A & B); // NAND
            3'b111: result = ~(A | B); // NOR
            default: result = 64'b0;
        endcase
        zero_flag = (result == 64'b0);
    end
endmodule