module cordic_vectoring (  
    input signed [3:0] x,  
    input signed [3:0] y,  
    output reg signed [3:0] theta,  
    output reg signed [3:0] magnitude  
);  

    reg signed [3:0] x_temp;  
    reg signed [3:0] y_temp;  
    reg signed [3:0] angle;  
    integer i;  

    always @(*) begin  
        x_temp = x;  
        y_temp = y;  
        angle = 0;  

        for (i = 0; i < 4; i = i + 1) begin  
            if (y_temp < 0) begin  
                x_temp = x_temp + (1 << i);  
                y_temp = y_temp + (1 << i);  
                angle = angle - (1 << i);  
            end else begin  
                x_temp = x_temp - (1 << i);  
                y_temp = y_temp - (1 << i);  
                angle = angle + (1 << i);  
            end  
        end  

        magnitude = x_temp + y_temp;  
        theta = angle;  
    end  
endmodule