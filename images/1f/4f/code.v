module ALU (
    input [31:0] A,
    input [31:0] B,
    input [2:0] OP,
    output reg [31:0] RESULT,
    output reg CARRY_OUT
);

always @(*) begin
    case(OP)
        3'b000: {CARRY_OUT, RESULT} = A + B;        // ADD
        3'b001: {CARRY_OUT, RESULT} = A - B;        // SUBTRACT
        3'b010: RESULT = A & B;                      // AND
        3'b011: RESULT = A | B;                      // OR
        3'b100: RESULT = A ^ B;                      // XOR
        default: RESULT = 32'b0;                     // Default case
    endcase
end

endmodule