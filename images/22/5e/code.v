module iir_filter(  
    input clk,  
    input rst,  
    input signed [15:0] x_n,  
    input signed [15:0] x_n1,  
    output reg signed [15:0] y_n  
);  
    reg signed [15:0] y_n1;  
    reg signed [15:0] y_n2;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            y_n <= 16'd0;  
            y_n1 <= 16'd0;  
            y_n2 <= 16'd0;  
        end else begin  
            y_n <= (0.5 * x_n) + (0.5 * x_n1) + (0.2 * y_n1) + (0.3 * y_n2);  
            y_n2 <= y_n1;  
            y_n1 <= y_n;  
        end  
    end  
endmodule