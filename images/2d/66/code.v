module adaptive_lms_filter #(parameter N=4, parameter mu=16'h0001) (  
    input clk,  
    input reset,  
    input [15:0] x,  
    input [15:0] d,  
    output reg [15:0] y  
);  
    reg [15:0] w [0:N-1]; // weights  
    reg [15:0] e; // error signal  
    reg [15:0] x_delayed [0:N-1]; // delayed input signals  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            for (i = 0; i < N; i = i + 1) begin  
                w[i] <= 16'h0000;  
            end  
            y <= 16'h0000;  
        end else begin  
            // Shift input signals  
            for (i = N-1; i > 0; i = i - 1) begin  
                x_delayed[i] <= x_delayed[i-1];  
            end  
            x_delayed[0] <= x;  

            // Calculate output  
            y <= 16'h0000;  
            for (i = 0; i < N; i = i + 1) begin  
                y <= y + (w[i] * x_delayed[i]);  
            end  

            // Calculate error  
            e <= d - y;  

            // Update weights  
            for (i = 0; i < N; i = i + 1) begin  
                w[i] <= w[i] + (mu * e * x_delayed[i]);  
            end  
        end  
    end  
endmodule