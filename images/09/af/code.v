module linear_regression #(parameter m = 1, parameter b = 0) (  
    input [31:0] x,  
    output reg [31:0] y  
);  
    always @(*) begin  
        y = (m * x) + b;  
    end  
endmodule