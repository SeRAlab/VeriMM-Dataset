module decision_tree_inference(  
    input [4:0] features,  // 5 binary input features  
    output reg decision     // 1-bit output decision  
);  
    always @(*) begin  
        if (features[0] == 1) begin  
            decision = 1;  
        end else if (features[1] == 1 && features[2] == 0) begin  
            decision = 0;  
        end else if (features[1] == 0 && features[3] == 1) begin  
            decision = 1;  
        end else if (features[1] == 0 && features[3] == 0) begin  
            decision = features[4];  
        end else begin  
            decision = 0;  // default case  
        end  
    end  
endmodule