module portfolio_optimizer(
    input [7:0] asset1_weight,
    input [7:0] asset2_weight,
    input [7:0] asset3_weight,
    output reg [7:0] total_weight
);
    always @(*) begin
        total_weight = asset1_weight + asset2_weight + asset3_weight;
        if (total_weight > 8'd100) begin
            total_weight = 8'd100; // Clamp to 100%
        end
    end
endmodule