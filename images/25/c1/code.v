module ALU (
    input [7:0] A,
    input [7:0] B,
    input [2:0] ALU_op,
    output reg [7:0] result,
    output reg carry_out
);
    always @(*) begin
        case (ALU_op)
            3'b000: {carry_out, result} = A + B; // ADD
            3'b001: {carry_out, result} = A - B; // SUBTRACT
            3'b010: result = A & B;              // AND
            3'b011: result = A | B;              // OR
            3'b100: result = A ^ B;              // XOR
            3'b101: result = ~A;                 // NOT A
            3'b110: result = ~(A & B);           // NAND
            3'b111: result = ~(A | B);           // NOR
            default: result = 8'b00000000;       // Default case
        endcase
    end
endmodule