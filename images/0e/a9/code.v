module portfolio_optimizer(
    input [4:0] assets,
    output [4:0] optimal_selection
);
    assign optimal_selection[0] = assets[0];
    assign optimal_selection[1] = assets[1];
    assign optimal_selection[2] = assets[2];
    assign optimal_selection[3] = assets[3];
    assign optimal_selection[4] = (assets[3]) ? 1'b0 : assets[4];
endmodule