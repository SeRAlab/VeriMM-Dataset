module portfolio_optimizer (
    input [4:0] weight1,
    input [4:0] weight2,
    output reg [4:0] optimized_weight1,
    output reg [4:0] optimized_weight2
);
    wire [5:0] total_weight;
    assign total_weight = weight1 + weight2;

    always @(*) begin
        if (total_weight > 16) begin
            optimized_weight1 = (weight1 * 16) / total_weight;
            optimized_weight2 = (weight2 * 16) / total_weight;
        end else begin
            optimized_weight1 = weight1;
            optimized_weight2 = weight2;
        end
    end
endmodule