module top_module(
    input [3:0] in0,
    input [3:0] in1,
    input SUB,
    output reg [3:0] out
);reg [3:0] sum1, sum2;

always @ (in0, in1, SUB) begin
    sum1 <= in0 + (SUB ? ~in1 + 1 : in1);
end

always @ (sum1) begin
    sum2 <= sum1;
end

always @ (sum2) begin
    out <= sum2;
end

endmodule