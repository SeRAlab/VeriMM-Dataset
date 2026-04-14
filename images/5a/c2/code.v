module top_module(
    input [7:0] operand1,
    input [7:0] operand2,
    input [1:0] operation,
    output reg [7:0] result
);always @(*) begin
    case(operation)
        2'b00: result = operand1 + operand2; // Addition
        2'b01: result = operand1 - operand2; // Subtraction
        2'b10: result = operand1 * operand2; // Multiplication
        2'b11: begin // Division
            if(operand2 == 0) begin
                result = 0;
            end else begin
                result = operand1 / operand2;
            end
        end
    endcase
end

endmodule