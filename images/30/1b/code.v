module fir_filter (  
    input [7:0] x,  
    output reg [7:0] y  
);  
    reg [7:0] coefficients [0:7];  
    integer i;  
    initial begin  
        coefficients[0] = 8'd1;  
        coefficients[1] = 8'd2;  
        coefficients[2] = 8'd3;  
        coefficients[3] = 8'd4;  
        coefficients[4] = 8'd5;  
        coefficients[5] = 8'd6;  
        coefficients[6] = 8'd7;  
        coefficients[7] = 8'd8;  
    end  
    always @(*) begin  
        y = 8'd0;  
        for (i = 0; i < 8; i = i + 1) begin  
            y = y + (x * coefficients[i]);  
        end  
    end  
endmodule