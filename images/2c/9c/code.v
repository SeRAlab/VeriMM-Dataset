module portfolio_optimizer(  
    input [1:0] asset1,  
    input [1:0] asset2,  
    input [1:0] asset3,  
    output [3:0] total_weight  
);  
    assign total_weight = asset1 + asset2 + asset3;  
endmodule