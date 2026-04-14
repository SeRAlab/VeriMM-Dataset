module fir_filter(  
    input signed [3:0] x,  
    output signed [5:0] y  
);  
    // FIR filter coefficients  
    parameter signed [3:0] h0 = 4'b0001;  
    parameter signed [3:0] h1 = 4'b0010;  
    parameter signed [3:0] h2 = 4'b0011;  
    parameter signed [3:0] h3 = 4'b0100;  
   
    wire signed [5:0] product0, product1, product2, product3;  
   
    assign product0 = x * h0;  
    assign product1 = x * h1;  
    assign product2 = x * h2;  
    assign product3 = x * h3;  
   
    assign y = product0 + product1 + product2 + product3;  
endmodule