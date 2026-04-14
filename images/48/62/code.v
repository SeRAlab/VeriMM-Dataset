module top_module(
    input clk,
    input rst,
    input signed [15:0] operand1,
    input signed [15:0] operand2,
    input [1:0] operation,
    output reg signed [15:0] result,
    output reg overflow,
    output reg zero
);always @(posedge clk, posedge rst) begin
    if (rst) begin
        result <= 0;
        overflow <= 0;
        zero <= 0;
    end else begin
        case (operation)
            2'b00: begin // addition
                result <= operand1 + operand2;
                overflow <= (result > 32767 || result < -32768);
                zero <= (result == 0);
            end
            2'b01: begin // subtraction
                result <= operand1 - operand2;
                overflow <= (result > 32767 || result < -32768);
                zero <= (result == 0);
            end
            2'b10: begin // multiplication
                result <= operand1 * operand2;
                overflow <= (result > 32767 || result < -32768);
                zero <= (result == 0);
            end
            2'b11: begin // division
                if (operand2 == 0) begin
                    result <= 0;
                    overflow <= 1;
                    zero <= 1;
                end else begin
                    result <= operand1 / operand2;
                    overflow <= (result > 32767 || result < -32768);
                    zero <= (result == 0);
                end
            end
        endcase
    end
end

endmodule