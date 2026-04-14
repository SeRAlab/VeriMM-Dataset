module top_module(input [7:0] a, input [7:0] b, input [2:0] op, output reg [15:0] res);always @(*) begin
        case(op)
            3'b000: res = a + b; // Addition
            3'b001: res = a - b; // Subtraction
            3'b010: res = a * b; // Multiplication
            3'b011: res = a / b; // Division
            default: res = 16'b0; // Default value
        endcase
    end

endmodule