module portfolio_optimizer (
    input [4:0] weights,
    input [4:0] max_weight,
    output reg [4:0] optimal_portfolio
);
    always @(*) begin
        if (weights <= max_weight)
            optimal_portfolio = weights;
        else
            optimal_portfolio = 5'b00000; // if exceeding max_weight, output zero
    end
endmodule