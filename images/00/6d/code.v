module portfolio_optimizer (
    input [4:0] risk_levels,  // 5-bit input for risk levels of the assets
    input [4:0] threshold,     // 5-bit input for the risk threshold
    output [4:0] decision      // 5-bit output for the decision on asset inclusion
);
    assign decision = (risk_levels <= threshold) ? risk_levels : 5'b00000;
endmodule