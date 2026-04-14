module portfolio_normalization (
    input [3:0] asset1,
    input [3:0] asset2,
    input [3:0] asset3,
    output reg [3:0] normalized_weight
);

    wire [4:0] sum;  // 5-bit to accommodate overflow
    assign sum = asset1 + asset2 + asset3;

    always @(*) begin
        if (sum == 0) begin
            normalized_weight = 4'b0000; // If sum is zero, output zero
        end else begin
            normalized_weight = (sum * 15) / sum; // Normalize and scale
        end
    end
endmodule