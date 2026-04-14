module knn_3inputs (input wire a, input wire b, input wire c, output wire majority);  
    assign majority = (a + b + c >= 2) ? 1'b1 : 1'b0;  
endmodule