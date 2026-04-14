module fir_filter (  
    input [3:0] x0,  
    input [3:0] x1,  
    input [3:0] x2,  
    input [3:0] x3,  
    output [3:0] y  
);  
    wire [7:0] product0;  
    wire [7:0] product1;  
    wire [7:0] product2;  
    wire [7:0] product3;  
    wire [7:0] sum;  

    assign product0 = x0 * 1;  
    assign product1 = x1 * 2;  
    assign product2 = x2 * 3;  
    assign product3 = x3 * 4;  

    assign sum = product0 + product1 + product2 + product3;  
    assign y = sum[3:0]; // Taking the lower 4 bits as output  

endmodule