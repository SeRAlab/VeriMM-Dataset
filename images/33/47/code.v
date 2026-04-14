module portfolio_optimizer(
    input [4:0] asset_a,
    input [4:0] asset_b,
    input [4:0] asset_c,
    input [4:0] asset_d,
    input [4:0] asset_e,
    output reg [4:0] allocation
);
    always @(*) begin
        if (asset_a >= asset_b && asset_a >= asset_c && asset_a >= asset_d && asset_a >= asset_e)
            allocation = 5'b00001; // Allocate to asset A
        else if (asset_b >= asset_a && asset_b >= asset_c && asset_b >= asset_d && asset_b >= asset_e)
            allocation = 5'b00010; // Allocate to asset B
        else if (asset_c >= asset_a && asset_c >= asset_b && asset_c >= asset_d && asset_c >= asset_e)
            allocation = 5'b00100; // Allocate to asset C
        else if (asset_d >= asset_a && asset_d >= asset_b && asset_d >= asset_c && asset_d >= asset_e)
            allocation = 5'b01000; // Allocate to asset D
        else
            allocation = 5'b10000; // Allocate to asset E
    end
endmodule