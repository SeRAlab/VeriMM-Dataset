module top_module(
    input reset,
    input clk,
    input [3:0] num1,
    input [3:0] num2,
    input op,
    output reg [4:0] result
);always @(posedge clk, posedge reset) begin
    if (reset) begin
        result <= 5'b0;
    end else begin
        if (op == 0) begin // addition
            result <= {1'b0, num1} + {1'b0, num2};
        end else begin // subtraction
            result <= {1'b0, num1} - {1'b0, num2};
        end
    end
end

endmodule