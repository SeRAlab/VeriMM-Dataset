module top_module(
    input clk,
    input [8:0] base,
    input [7:0] exponent,
    input reset,
    output reg [99:0] result,
    output reg isDone
);reg [7:0] count;
    reg [99:0] temp;

    always @(posedge clk) begin
        if (reset) begin
            count <= 0;
            result <= 0;
            isDone <= 0;
        end
        else if (count < exponent) begin
            temp <= result;
            result <= (count == 0) ? base : result * base;
            count <= count + 1;
        end
        else begin
            isDone <= 1;
        end
    end

endmodule