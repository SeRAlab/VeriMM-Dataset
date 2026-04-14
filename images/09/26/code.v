module butterworth_filter (  
    input [7:0] x,  
    output reg [7:0] y  
);  
    reg [7:0] a0, a1, a2;  
    reg [7:0] b1, b2;  
    reg [7:0] x1, x2, y1, y2;  

    // Coefficients for 2nd order Butterworth filter  
    initial begin  
        a0 = 8'd1;  
        a1 = 8'd2;  
        a2 = 8'd1;  
        b1 = 8'd2;  
        b2 = 8'd1;  
    end  

    always @(*) begin  
        y = (a0*x + a1*x1 + a2*x2 - b1*y1 - b2*y2) >> 2;  
        x2 = x1;  
        x1 = x;  
        y2 = y1;  
        y1 = y;  
    end  
endmodule