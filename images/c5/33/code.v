module multiplier(
    input signed [7:0] a,
    input signed [7:0] b,
    input sel,
    input reset,
    input clk,
    output signed [15:0] out
);

reg signed [15:0] product;
reg signed [15:0] sum;

always @(posedge clk) begin
    if (reset) begin
        product <= 0;
        sum <= 0;
    end else begin
        if (sel) begin
            sum <= a + b;
        end else begin
            product <= a * b;
        end
    end
end

assign out = sel ? sum : product;

endmodule