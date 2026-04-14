module butterworth_filter(input [3:0] x,  
                          output reg [3:0] y);  
    parameter b0 = 4'd1;  
    parameter b1 = 4'd2;  
    parameter b2 = 4'd1;  
    parameter a1 = 4'd2;  
    parameter a2 = 4'd1;  
   
    reg [3:0] x1, x2;  
    reg [3:0] y1, y2;  

    always @(*) begin  
        y = b0 * x + b1 * x1 + b2 * x2 - a1 * y1 - a2 * y2;  
        x2 = x1;  
        x1 = x;  
        y2 = y1;  
        y1 = y;  
    end  
endmodule