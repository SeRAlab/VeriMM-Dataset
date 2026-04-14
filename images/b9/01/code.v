module top_module(a, b, op, result);input [7:0] a;
input [7:0] b;
input [1:0] op;
output reg [7:0] result;

always @(*) begin
    case (op)
        2'b00: result = a + b; // addition
        2'b01: result = a - b; // subtraction
        2'b10: result = a * b; // multiplication
        2'b11: begin // division
            if (b == 0) begin
                result = 8'h00; // division by zero
            end else begin
                result = a / b; // quotient
                result = result << 8; // shift quotient to MSB
                result = result | (a % b); // add remainder to LSB
            end
        end
    endcase
end

endmodule