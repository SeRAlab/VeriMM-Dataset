module portfolio_optimizer (
    input [4:0] investment1,
    input [4:0] investment2,
    input [4:0] investment3,
    output [4:0] optimal_investment
);

assign optimal_investment = investment1 & investment2 & investment3;

endmodule