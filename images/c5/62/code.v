module simple_calculator(
    input [15:0] operand_a,
    input [15:0] operand_b,
    input [1:0] operation,
    output reg [15:0] result
);

always @* begin
    case(operation)
        2'b00: result = operand_a + operand_b; // addition
        2'b01: result = operand_a - operand_b; // subtraction
        2'b10: result = operand_a * operand_b; // multiplication
        2'b11: result = operand_a / operand_b; // division
    endcase
end

endmodule