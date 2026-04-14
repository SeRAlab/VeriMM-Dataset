module top_module(
    input [3:0] a,
    input [3:0] b,
    output reg equal,
    output reg greater,
    output reg less
);always @(*) begin
        if (a == b) begin
            equal = 1;
            greater = 0;
            less = 0;
        end else if (a > b) begin
            equal = 0;
            greater = 1;
            less = 0;
        end else begin
            equal = 0;
            greater = 0;
            less = 1;
        end
    end

endmodule