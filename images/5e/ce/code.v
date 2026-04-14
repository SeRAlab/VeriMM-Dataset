module top_module(
    input clk,
    input rst,
    input signed [7:0] a,
    input signed [7:0] b,
    input [2:0] op,
    output reg signed [7:0] result,
    output reg of
);always @(posedge clk) begin
    if (rst) begin
        result <= 0;
        of <= 0;
    end else begin
        case (op)
            3'b000: begin // addition
                if ((b > 0 && a > (127 - b)) || (b < 0 && a < (-128 - b))) begin
                    of <= 1;
                end else begin
                    of <= 0;
                end
                result <= a + b;
            end
            3'b001: begin // subtraction
                if ((b < 0 && a > (127 + b)) || (b > 0 && a < (-128 + b))) begin
                    of <= 1;
                end else begin
                    of <= 0;
                end
                result <= a - b;
            end
            3'b010: begin // multiplication
                if ((a == -128 && b == -1) || (b == -128 && a == -1)) begin
                    of <= 1;
                end else begin
                    of <= 0;
                end
                result <= a * b;
            end
            3'b011: begin // division
                if (b == 0) begin
                    of <= 1;
                end else begin
                    of <= 0;
                end
                result <= a / b;
            end
        endcase
    end
end

endmodule