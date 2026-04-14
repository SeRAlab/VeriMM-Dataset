module top_module(
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] S
);reg [3:0] sum1, sum2;

always @(A, B) begin
    sum1 <= A + B;
end

always @(sum1) begin
    if (sum1 > 15) begin
        sum2 <= sum1 - 16;
    end
    else begin
        sum2 <= sum1;
    end
end

always @(sum2) begin
    S <= sum2;
end

endmodule