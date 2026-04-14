module adaptive_lms_filter #(parameter N = 4, parameter mu = 8'b00000001) (  
    input clk,  
    input rst,  
    input signed [15:0] x,  // Input signal  
    input signed [15:0] d,  // Desired signal  
    output reg signed [15:0] y,  // Filter output  
    output reg signed [15:0] e  // Error signal  
);  
    reg signed [15:0] w [0:N-1];  // Coefficients  
    reg signed [15:0] x_delayed [0:N-1]; // Delayed inputs  
    integer i;  

    // Initialize coefficients  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            for (i = 0; i < N; i = i + 1) begin  
                w[i] <= 16'b0;  
            end  
        end else begin  
            // Update delayed inputs  
            x_delayed[0] <= x;  
            for (i = 1; i < N; i = i + 1) begin  
                x_delayed[i] <= x_delayed[i-1];  
            end  

            // Calculate filter output  
            y <= 0;  
            for (i = 0; i < N; i = i + 1) begin  
                y <= y + w[i] * x_delayed[i];  
            end  

            // Calculate error  
            e <= d - y;  

            // Update coefficients  
            for (i = 0; i < N; i = i + 1) begin  
                w[i] <= w[i] + (mu * e * x_delayed[i]) >> 8;  
            end  
        end  
    end  
endmodule