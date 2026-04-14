module portfolio_optimizer (
    input [7:0] asset1,
    input [7:0] asset2,
    input [7:0] asset3,
    output reg [1:0] selected_asset
);

always @(*) begin
    if (asset1 >= asset2 && asset1 >= asset3) begin
        selected_asset = 2'b00; // Asset 1
    end else if (asset2 >= asset1 && asset2 >= asset3) begin
        selected_asset = 2'b01; // Asset 2
    end else begin
        selected_asset = 2'b10; // Asset 3
    end
end

endmodule