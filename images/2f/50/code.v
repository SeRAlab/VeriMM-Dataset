module linear_regression (  
    input [15:0] x, // Input feature  
    input signed [15:0] slope, // Slope coefficient  
    input signed [15:0] intercept, // Intercept coefficient  
    output signed [31:0] y // Output predicted value  
);  
    assign y = (slope * x) + intercept;  
endmodule