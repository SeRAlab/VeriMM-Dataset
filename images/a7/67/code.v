module top_module(
    input [31:0] operand1,
    input [31:0] operand2,
    input [1:0] operation,
    output reg [31:0] result
);always @(*) begin
    case(operation)
        2'b00: result = operand1 + operand2;
        2'b01: result = operand1 - operand2;
        2'b10: result = operand1 * operand2;
        2'b11: result = operand1 / operand2;
    endcase
end

endmodule