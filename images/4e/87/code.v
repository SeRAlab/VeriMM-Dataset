module top_module(
    input signed [7:0] a,
    input signed [7:0] b,
    input [1:0] op,
    output reg signed [7:0] sum,
    output reg signed [7:0] difference,
    output reg signed [15:0] product,
    output reg signed [7:0] quotient
);always @(*) begin
        case(op)
            2'b00: begin // Addition
                sum = a + b;
            end
            2'b01: begin // Subtraction
                difference = a - b;
            end
            2'b10: begin // Multiplication
                product = a * b;
            end
            2'b11: begin // Division
                quotient = a / b;
            end
        endcase
    end

endmodule