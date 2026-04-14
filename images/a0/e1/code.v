module top_module(
    input signed [7:0] num1,
    input signed [7:0] num2,
    input [1:0] opcode,
    input clk,
    output reg signed [7:0] result
);always @(posedge clk) begin
    case(opcode)
        2'b00: result <= num1 + num2; // Addition
        2'b01: result <= num1 - num2; // Subtraction
        2'b10: result <= num1 * num2; // Multiplication
        2'b11: result <= num1 / num2; // Division
    endcase
end

endmodule