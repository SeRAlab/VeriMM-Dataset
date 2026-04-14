module portfolio_optimizer (
    input [4:0] asset1,
    input [4:0] asset2,
    input [4:0] asset3,
    output reg [4:0] optimal_asset
);

always @(*) begin
    if (asset1 >= asset2 && asset1 >= asset3) 
        optimal_asset = asset1;
    else if (asset2 >= asset1 && asset2 >= asset3) 
        optimal_asset = asset2;
    else 
        optimal_asset = asset3;
end

endmodule