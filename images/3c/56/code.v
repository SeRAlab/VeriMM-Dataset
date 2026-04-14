module portfolio_optimizer (
    input [3:0] asset1_return,
    input [3:0] asset2_return,
    input [3:0] asset3_return,
    output reg [2:0] optimal_allocation
);
    always @(*) begin
        if (asset1_return >= asset2_return && asset1_return >= asset3_return)
            optimal_allocation = 3'b001; // Invest in asset 1
        else if (asset2_return >= asset1_return && asset2_return >= asset3_return)
            optimal_allocation = 3'b010; // Invest in asset 2
        else
            optimal_allocation = 3'b100; // Invest in asset 3
    end
endmodule