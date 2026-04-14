module knn_classifier (  
    input [2:0] data,  
    output reg [1:0] classification  
);  
    always @(*) begin  
        if (data[0] + data[1] + data[2] <= 1)  
            classification = 2'b00; // Class 0  
        else if (data[0] + data[1] + data[2] <= 3)  
            classification = 2'b01; // Class 1  
        else  
            classification = 2'b10; // Class 2  
    end  
endmodule