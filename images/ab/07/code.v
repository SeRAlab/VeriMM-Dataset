module top_module(
    input [7:0] num1,
    input [7:0] num2,
    input [1:0] op,
    output reg [7:0] result
);always @(*) begin
    case(op)
        2'b00: result = num1 + num2; // addition
        2'b01: result = num1 - num2; // subtraction
        2'b10: result = num1 * num2; // multiplication
        2'b11: begin // division
            if(num2 == 0) begin
                result = 8'b00000000; // if num2 is 0, result should be 0
            end
            else begin
                result = num1 / num2; // integer division
            end
        end
    endcase
end

endmodule