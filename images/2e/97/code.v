module fir_filter (  
    input wire clk,  
    input wire rst,  
    input wire [15:0] x,  
    output reg [15:0] y  
);  
    parameter N = 32;  
    reg [15:0] h [0:N-1];  
    reg [15:0] x_delay [0:N-1];  
    integer i;  

    initial begin  
        // Example filter coefficients  
        h[0] = 16'h0001;  
        h[1] = 16'h0002;  
        h[2] = 16'h0001;  
        // ... initialize other coefficients ...  
        h[31] = 16'h0000;  
    end  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            y <= 16'h0000;  
            for (i = 0; i < N; i = i + 1)  
                x_delay[i] <= 16'h0000;  
        end else begin  
            // Shift input samples  
            for (i = N-1; i > 0; i = i - 1)  
                x_delay[i] <= x_delay[i-1];  
            x_delay[0] <= x;  
      
            // Compute output  
            y <= 16'h0000;  
            for (i = 0; i < N; i = i + 1)  
                y <= y + (x_delay[i] * h[i]);  
        end  
    end  
endmodule