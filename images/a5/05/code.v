module top_module(
    input [3:0] a,
    input [3:0] b,
    input cin,
    input reset,
    output reg [3:0] sum
);always @(*) begin
        if (reset) begin
            sum <= 4'b0000;
        end else begin
            sum <= {cin, a} + b;
            if (sum > 4'b1111) begin
                sum <= sum[3:0];
            end
        end
    end

endmodule