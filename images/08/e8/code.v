module PortfolioOptimization (
    input [7:0] weight1,  // weight of asset 1 (0-100)
    input [7:0] weight2,  // weight of asset 2 (0-100)
    input [7:0] weight3,  // weight of asset 3 (0-100)
    input [7:0] return1,  // expected return of asset 1
    input [7:0] return2,  // expected return of asset 2
    input [7:0] return3,  // expected return of asset 3
    output reg [15:0] portfolio_return // expected return of the portfolio
);

always @(*) begin
    portfolio_return = (weight1 * return1 + weight2 * return2 + weight3 * return3) / 100;
end

endmodule