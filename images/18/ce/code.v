module ALU_64bit (
    input [63:0] A,
    input [63:0] B,
    input [1:0] opcode, // 00: ADD, 01: SUB, 10: AND
    output reg [63:0] result
);
    always @(*) begin
        case (opcode)
            2'b00: result = A + B; // ADD
            2'b01: result = A - B; // SUB
            2'b10: result = A & B; // AND
            default: result = 64'b0; // Default case (optional)
        endcase
    end
endmodule