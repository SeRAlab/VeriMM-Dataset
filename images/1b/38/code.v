module logistic_regression (  
    input wire x1,  
    input wire x2,  
    input wire x3,  
    output wire y  
);  
    wire [1:0] sum;  
    assign sum = x1 + x2 + x3;  
    assign y = (sum >= 2) ? 1'b1 : 1'b0;  
endmodule