module decision_tree (
    input [3:0] feature1, 
    input [3:0] feature2, 
    input [3:0] feature3, 
    output reg [1:0] class_out 
);  
    always @(*) begin  
        if (feature1 > 4) begin  
            if (feature2 > 3)  
                class_out = 2'b00; // Class 1  
            else  
                class_out = 2'b01; // Class 2  
        end else begin  
            if (feature3 == 1)  
                class_out = 2'b10; // Class 3  
            else  
                class_out = 2'b11; // Class 4  
        end  
    end  
endmodule