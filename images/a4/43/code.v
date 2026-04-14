module top_module(output reg [7:0] result, input [7:0] num1, input [7:0] num2, input [2:0] op);always @ (*)
    begin
        case (op)
            3'b000: result = num1 + num2; // addition
            3'b001: result = num1 - num2; // subtraction
            3'b010: result = num1 * num2; // multiplication
            3'b011: result = num1 / num2; // division
            default: result = 8'b0; // default case
        endcase
    end
    
endmodule