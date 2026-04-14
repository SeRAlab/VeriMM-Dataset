module top_module(
    input [3:0] a,
    input [3:0] b,
    output reg [3:0] sum
);reg [3:0] carry;
reg [3:0] intermediate_sum1;
reg [3:0] intermediate_sum2;

always @ (a or b) begin
    intermediate_sum1 <= a + b;
end

always @ (intermediate_sum1 or carry) begin
    intermediate_sum2 <= intermediate_sum1 + carry;
end

always @ (intermediate_sum2) begin
    if (intermediate_sum2 > 15) begin
        sum <= intermediate_sum2[3:0];
        carry <= 1;
    end else begin
        sum <= intermediate_sum2;
        carry <= 0;
    end
end

endmodule