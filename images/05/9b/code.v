module ALU (
    input [15:0] A,
    input [15:0] B,
    input [2:0] op,
    output reg [15:0] Result,
    output reg CarryOut
);

always @(*) begin
    case (op)
        3'b000: Result = A & B;                // AND
        3'b001: Result = A | B;                // OR
        3'b010: Result = A ^ B;                // XOR
        3'b011: {CarryOut, Result} = A + B;    // ADD
        3'b100: {CarryOut, Result} = A - B;    // SUBTRACT
        3'b101: Result = ~(A & B);             // NAND
        3'b110: Result = ~(A | B);             // NOR
        3'b111: Result = ~(A ^ B);             // XNOR
        default: Result = 16'b0000000000000000; // Default case
    endcase
end

endmodule