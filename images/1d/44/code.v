module monte_carlo_pi #(parameter N = 5) (  
    input [N*8-1:0] x,  
    input [N*8-1:0] y,  
    input [31:0] total_points,  
    output reg [31:0] pi_estimate  
);  

    integer i;  
    integer inside_circle;  

    always @(*) begin  
        inside_circle = 0;  
        for (i = 0; i < N; i = i + 1) begin  
            if ((x[i*8+:8] * x[i*8+:8] + y[i*8+:8] * y[i*8+:8]) <= (255 * 255)) begin  
                inside_circle = inside_circle + 1;  
            end  
        end  
        pi_estimate = (4 * inside_circle) / total_points;  
    end  
endmodule