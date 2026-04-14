module top_module(
    input clk,
    input rst,
    input [1:0] op,
    input signed [7:0] a,
    input signed [7:0] b,
    output reg signed [7:0] result
);reg signed [15:0] temp; // Temporary register to store intermediate results

always @(posedge clk) begin
    if (rst) begin
        result <= 0;
        temp <= 0;
    end else begin
        case (op)
            2'b00: begin // Addition
                temp <= a + b;
                result <= temp[7:0];
            end
            2'b01: begin // Subtraction
                temp <= a - b;
                result <= temp[7:0];
            end
            2'b10: begin // Multiplication
                temp <= a * b;
                result <= temp[7:0];
            end
            2'b11: begin // Division
                if (b == 0) begin
                    result <= 8'h7F; // Division by zero error
                end else begin
                    temp <= a / b;
                    result <= temp[7:0];
                end
            end
        endcase
    end
end

endmodule