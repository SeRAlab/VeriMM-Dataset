module portfolio_optimizer (
    input [4:0] asset_returns,
    output reg [4:0] allocation
);
    always @(*) begin
        if (asset_returns[0] >= asset_returns[1] && asset_returns[0] >= asset_returns[2] && asset_returns[0] >= asset_returns[3] && asset_returns[0] >= asset_returns[4]) begin
            allocation = 5'b00001; // Invest in asset 0
        end else if (asset_returns[1] >= asset_returns[0] && asset_returns[1] >= asset_returns[2] && asset_returns[1] >= asset_returns[3] && asset_returns[1] >= asset_returns[4]) begin
            allocation = 5'b00010; // Invest in asset 1
        end else if (asset_returns[2] >= asset_returns[0] && asset_returns[2] >= asset_returns[1] && asset_returns[2] >= asset_returns[3] && asset_returns[2] >= asset_returns[4]) begin
            allocation = 5'b00100; // Invest in asset 2
        end else if (asset_returns[3] >= asset_returns[0] && asset_returns[3] >= asset_returns[1] && asset_returns[3] >= asset_returns[2] && asset_returns[3] >= asset_returns[4]) begin
            allocation = 5'b01000; // Invest in asset 3
        end else begin
            allocation = 5'b10000; // Invest in asset 4
        end
    end
endmodule