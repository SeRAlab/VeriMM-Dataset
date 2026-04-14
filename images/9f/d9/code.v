module top_module(a, b, op, sum, difference, product, quotient);input [15:0] a, b;
    input [1:0] op;
    output reg [15:0] sum, difference, product, quotient;

    always @ (a or b or op) begin
        case (op)
            2'b00: begin // addition
                sum = a + b;
                difference = 16'b0;
                product = 16'b0;
                quotient = 16'b0;
            end
            2'b01: begin // subtraction
                sum = 16'b0;
                difference = a - b;
                product = 16'b0;
                quotient = 16'b0;
            end
            2'b10: begin // multiplication
                sum = 16'b0;
                difference = 16'b0;
                product = a * b;
                quotient = 16'b0;
            end
            2'b11: begin // division
                sum = 16'b0;
                difference = 16'b0;
                product = 16'b0;
                quotient = a / b;
            end
        endcase
    end

endmodule