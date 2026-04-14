module adaptive_lms #(parameter N = 5, parameter mu = 8'h01) (  
    input clk,  
    input rst,  
    input signed [15:0] x, // input signal  
    input signed [15:0] d, // desired signal  
    output signed [15:0] y  // output signal  
);  
    reg signed [15:0] w [0:N-1]; // weight coefficients  
    reg signed [15:0] y_reg; // output signal  
    reg signed [15:0] e; // error signal  
    integer i;  
   
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            for (i = 0; i < N; i = i + 1)  
                w[i] <= 16'h0000; // Initialize weights to zero  
            y_reg <= 16'h0000;  
        end else begin  
            // Compute output  
            y_reg = 0;  
            for (i = 0; i < N; i = i + 1)  
                y_reg = y_reg + w[i] * x; // Dot product of weights and inputs  
           
            // Compute error  
            e = d - y_reg;  
           
            // Update weights  
            for (i = 0; i < N; i = i + 1)  
                w[i] <= w[i] + (mu * e * x); // LMS weight update  
        end  
    end  
    
    assign y = y_reg;  
endmodule