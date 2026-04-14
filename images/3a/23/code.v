module portfolio_optimizer (
    input [4:0] weight1, // Weight of Asset 1
    input [4:0] weight2, // Weight of Asset 2
    input [4:0] weight3, // Weight of Asset 3
    output reg [7:0] expected_return // Expected return output
);
    always @(*) begin
        // Ensure the weights sum to 100%
        if ((weight1 + weight2 + weight3) != 5'd100) begin
            expected_return = 8'd0; // Invalid input case
        end else begin
            expected_return = (weight1 * 10 / 100) + (weight2 * 15 / 100) + (weight3 * 20 / 100);
        end
    end
endmodule