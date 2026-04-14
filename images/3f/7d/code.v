module PortfolioOptimization (
    input [4:0] investment1,
    input [4:0] investment2,
    input [4:0] investment3,
    output reg [4:0] output1,
    output reg [4:0] output2,
    output reg [4:0] output3
);

    wire [9:0] total_investment;

    assign total_investment = investment1 + investment2 + investment3;

    always @(*) begin
        if (total_investment != 0) begin
            output1 = (investment1 * 32) / total_investment; // Scale to 5 bits
            output2 = (investment2 * 32) / total_investment;
            output3 = (investment3 * 32) / total_investment;
        end else begin
            output1 = 5'b00000;
            output2 = 5'b00000;
            output3 = 5'b00000;
        end
    end
endmodule