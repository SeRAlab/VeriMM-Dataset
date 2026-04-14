module portfolio_optimizer(  
    input [7:0] asset1,  
    input [7:0] asset2,  
    input [7:0] asset3,  
    input [7:0] asset4,  
    input [7:0] asset5,  
    output reg [7:0] total_weight,  
    output reg [7:0] average_weight  
);  
    always @(*) begin  
        total_weight = (asset1 + asset2 + asset3 + asset4 + asset5) % 256;  
        average_weight = total_weight / 5;  
    end  
endmodule