module top_module(
    input [3:0] operand1,
    input [3:0] operand2,
    input [1:0] operator,
    input clear,
    output reg [3:0] result
);always @(*) begin
    case(operator)
        2'b00: result = operand1 + operand2; // Addition
        2'b01: result = operand1 - operand2; // Subtraction
        2'b10: result = operand1 * operand2; // Multiplication
        2'b11: result = operand1 / operand2; // Division
    endcase
end

always @(posedge clear) begin
    if(clear) begin
        result <= 4'b0000; // Reset calculator and set output to 0
    end
end

endmodule