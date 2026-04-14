module fir_filter (  
    input [3:0] x,  
    output [7:0] y  
);  
    reg [7:0] y;  
    reg [3:0] x1, x2, x3;  

    always @(*) begin  
        // Shift the input samples  
        x3 = x2;  
        x2 = x1;  
        x1 = x;  
        
        // Compute the output using FIR coefficients [1, 2, 3, 4]  
        y = (1 * x1) + (2 * x2) + (3 * x3) + (4 * x3);  
    end  
endmodule