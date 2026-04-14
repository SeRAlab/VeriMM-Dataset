module portfolio_optimizer(  
    input [4:0] asset1,  
    input [4:0] asset2,  
    input [4:0] asset3,  
    output reg [4:0] normalized_weight  
);  

    wire [4:0] total_weight;  
    wire [4:0] max_weight;  

    assign total_weight = asset1 + asset2 + asset3;  
    assign max_weight = (asset1 > asset2) ? (asset1 > asset3 ? asset1 : asset3) : (asset2 > asset3 ? asset2 : asset3);  

    always @(*) begin  
        if (total_weight != 0)  
            normalized_weight = (max_weight * 31) / total_weight;  
        else  
            normalized_weight = 0;  
    end  
endmodule