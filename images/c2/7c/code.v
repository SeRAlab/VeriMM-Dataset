module simple_calculator(
    input [1:0] operation,
    input signed [63:0] operands,
    output signed [31:0] result
);

reg signed [31:0] op1;
reg signed [31:0] op2;
reg signed [31:0] res;

always @(*) begin
    op1 = operands[31:0];
    op2 = operands[63:32];
    case(operation)
        2'b00: res = op1 + op2; // Addition
        2'b01: res = op1 - op2; // Subtraction
        2'b10: res = op1 * op2; // Multiplication
        2'b11: res = op1 / op2; // Division
    endcase
end

assign result = res;

endmodule