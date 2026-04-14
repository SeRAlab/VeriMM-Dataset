module portfolio_optimizer(
    input [7:0] asset1_return,
    input [7:0] asset2_return,
    input [7:0] asset3_return,
    output reg [7:0] weight1,
    output reg [7:0] weight2,
    output reg [7:0] weight3
);
    always @(*) begin
        // Simple logic: allocate weights based on returns
        if (asset1_return >= asset2_return && asset1_return >= asset3_return) begin
            weight1 = 8'd100;
            weight2 = 8'd0;
            weight3 = 8'd0;
        end else if (asset2_return >= asset1_return && asset2_return >= asset3_return) begin
            weight1 = 8'd0;
            weight2 = 8'd100;
            weight3 = 8'd0;
        end else begin
            weight1 = 8'd0;
            weight2 = 8'd0;
            weight3 = 8'd100;
        end
    end
endmodule