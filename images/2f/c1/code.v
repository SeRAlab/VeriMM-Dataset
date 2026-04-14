module portfolio_optimizer (
    input [15:0] returns_asset1,
    input [15:0] returns_asset2,
    input [15:0] returns_asset3,
    input [15:0] risks_asset1,
    input [15:0] risks_asset2,
    input [15:0] risks_asset3,
    output reg [7:0] weight_asset1,
    output reg [7:0] weight_asset2,
    output reg [7:0] weight_asset3
);

    reg [31:0] total_returns;
    reg [31:0] total_risks;

    always @(*) begin
        total_returns = returns_asset1 + returns_asset2 + returns_asset3;
        total_risks = risks_asset1 + risks_asset2 + risks_asset3;

        weight_asset1 = (returns_asset1 * 256) / total_returns;
        weight_asset2 = (returns_asset2 * 256) / total_returns;
        weight_asset3 = (returns_asset3 * 256) / total_returns;
    end
endmodule