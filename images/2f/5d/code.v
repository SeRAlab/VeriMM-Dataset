module monte_carlo_pi_estimator(  
    input [7:0] X,  
    input [7:0] Y,  
    output reg inside_circle  
);  
    always @(*) begin  
        if ((X * X + Y * Y) <= (255 * 255))  
            inside_circle = 1;  
        else  
            inside_circle = 0;  
    end  
endmodule