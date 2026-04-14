module top_module(
    input signed [15:0] a,
    input signed [15:0] b,
    input sub,
    output reg signed [15:0] result,
    output reg overflow
);always @(*) begin
        if (sub) begin
            result = a - b;
            overflow = ((a < 0) & (b > 0) & (result > 0)) | ((a > 0) & (b < 0) & (result < 0));
        end else begin
            result = a + b;
            overflow = ((a > 0) & (b > 0) & (result < 0)) | ((a < 0) & (b < 0) & (result > 0));
        end
    end

endmodule