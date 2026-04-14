module alu_32bit (
    input [31:0] A,
    input [31:0] B,
    input [2:0] control,
    output reg [31:0] result,
    output reg zero
);

always @(*) begin
    case(control)
        3'b000: result = A & B;          // AND
        3'b001: result = A | B;          // OR
        3'b010: result = A + B;          // ADD
        3'b011: result = A - B;          // SUBTRACT
        3'b100: result = ~(A | B);       // NOR
        3'b101: result = ~(A & B);       // NAND
        3'b110: result = A ^ B;          // XOR
        3'b111: result = ~(A ^ B);       // XNOR
        default: result = 32'b0;         // default case
    endcase
    zero = (result == 32'b0) ? 1'b1 : 1'b0; // Set zero flag
end

endmodule