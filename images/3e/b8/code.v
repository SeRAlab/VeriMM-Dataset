module iir_filter #(parameter N = 4) (  
    input clk,  
    input rst,  
    input signed [15:0] x,  
    output reg signed [15:0] y  
);  
    reg signed [15:0] a [0:N-1];  
    reg signed [15:0] b [0:N-1];  
    reg signed [15:0] x_reg [0:N-1];  
    reg signed [15:0] y_reg [0:N-1];  
    
    integer i;  
    
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            y <= 0;  
            for (i = 0; i < N; i = i + 1) begin  
                x_reg[i] <= 0;  
                y_reg[i] <= 0;  
            end  
        end else begin  
            x_reg[0] <= x;  
            for (i = 1; i < N; i = i + 1) begin  
                x_reg[i] <= x_reg[i-1];  
                y_reg[i] <= y_reg[i-1];  
            end  
            y <= 0;  
            for (i = 0; i < N; i = i + 1) begin  
                y <= y + (b[i] * x_reg[i]) - (a[i] * y_reg[i]);  
            end  
        end  
    end  
endmodule