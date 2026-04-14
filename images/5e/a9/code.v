module top_module(
    input [7:0] operand1,
    input [7:0] operand2,
    input [2:0] opcode,
    output reg [7:0] result
);always @(*)
begin
    case(opcode)
        3'b000: result = operand1 + operand2; // Addition
        3'b001: result = operand1 - operand2; // Subtraction
        3'b010: result = operand1 * operand2; // Multiplication
        3'b011: begin // Division
            if(operand2 == 0) // Handle divide by zero
                result = 8'b11111111;
            else
                result = operand1 / operand2;
        end
        default: result = 8'b0; // Invalid opcode, set result to 0
    endcase
end

endmodule