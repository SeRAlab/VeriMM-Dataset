module max_return(
    input [15:0] asset1,
    input [15:0] asset2,
    input [15:0] asset3,
    input [15:0] asset4,
    input [15:0] asset5,
    output reg [15:0] max_return_out
);
    always @(*) begin
        max_return_out = asset1; // Initialize to first asset
        if (asset2 > max_return_out) max_return_out = asset2;
        if (asset3 > max_return_out) max_return_out = asset3;
        if (asset4 > max_return_out) max_return_out = asset4;
        if (asset5 > max_return_out) max_return_out = asset5;
    end
endmodule