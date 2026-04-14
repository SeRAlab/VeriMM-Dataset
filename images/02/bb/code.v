module iir_filter(input clk,  
                  input rst,  
                  input signed [15:0] x,  
                  output reg signed [15:0] y);  
                  
    parameter signed [15:0] b0 = 16'h0FFF; // Feedforward coefficient  
    parameter signed [15:0] b1 = 16'h0FFF; // Feedforward coefficient  
    parameter signed [15:0] b2 = 16'h0FFF; // Feedforward coefficient  
    parameter signed [15:0] a1 = 16'h1FFF; // Feedback coefficient  
    parameter signed [15:0] a2 = 16'h1FFF; // Feedback coefficient  

    reg signed [15:0] x1, x2;  
    reg signed [15:0] y1, y2;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            x1 <= 0;  
            x2 <= 0;  
            y1 <= 0;  
            y2 <= 0;  
            y <= 0;  
        end else begin  
            y <= b0 * x + b1 * x1 + b2 * x2 - a1 * y1 - a2 * y2;  
            x2 <= x1;  
            x1 <= x;  
            y2 <= y1;  
            y1 <= y;  
        end  
    end  
endmodule