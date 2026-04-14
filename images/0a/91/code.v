module linear_regression (  
    input [7:0] x1,  
    input [7:0] x2,  
    output reg [15:0] y  
);  
    parameter w1 = 8'd2;  // weight for x1  
    parameter w2 = 8'd3;  // weight for x2  
    parameter b = 8'd5;   // bias  

    always @(*) begin  
        y = (w1 * x1) + (w2 * x2) + b;  
    end  
endmodule