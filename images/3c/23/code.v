module PortfolioOptimizer(
    input clk,
    input rst,
    input [7:0] asset1,
    input [7:0] asset2,
    input [7:0] asset3,
    input [7:0] threshold,
    output reg optimal
);
    reg [7:0] avg_return;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            avg_return <= 8'b0;
            optimal <= 1'b0;
        end else begin
            avg_return <= (asset1 + asset2 + asset3) / 3;
            if (avg_return > threshold) begin
                optimal <= 1'b1;
            end else begin
                optimal <= 1'b0;
            end
        end
    end
endmodule