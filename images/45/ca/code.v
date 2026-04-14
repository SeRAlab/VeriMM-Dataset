module top_module(
    input [3:0] a,
    input [3:0] b,
    output reg [3:0] sum
);always @(*) begin
    sum = a + b;
    if (sum < 0) begin
        sum = 4'b0000;
    end
    else if (sum > 15) begin
        sum = sum[3:0];
    end
end

endmodule