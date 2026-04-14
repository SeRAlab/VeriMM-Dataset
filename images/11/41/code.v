module portfolio_optimizer (
    input [3:0] asset1,
    input [3:0] asset2,
    input [3:0] asset3,
    output reg [3:0] optimized_return
);
    always @(*) begin
        optimized_return = (asset1 + asset2 + asset3) / 3;
    end
endmodule