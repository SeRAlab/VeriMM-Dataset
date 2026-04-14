module adaptive_lms_filter(input clk,  
                            input rst,  
                            input signed [15:0] x, // Input signal  
                            input signed [15:0] d, // Desired output  
                            output signed [15:0] y, // Filter output  
                            output signed [15:0] w0, // Weight 0  
                            output signed [15:0] w1, // Weight 1  
                            output signed [15:0] w2); // Weight 2  

    reg signed [15:0] w [0:2]; // Weights  
    reg signed [15:0] y_temp;  
    reg signed [15:0] e; // Error signal  
    parameter signed [15:0] mu = 16'h0001; // Step size  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            w[0] <= 16'b0;  
            w[1] <= 16'b0;  
            w[2] <= 16'b0;  
        end else begin  
            // Compute filter output  
            y_temp <= (w[0] * x) + (w[1] * x) + (w[2] * x);  
            // Compute error  
            e <= d - y_temp;  
            // Weight update  
            w[0] <= w[0] + (mu * e * x);  
            w[1] <= w[1] + (mu * e * x);  
            w[2] <= w[2] + (mu * e * x);  
        end  
    end  

    assign y = y_temp;  
    assign w0 = w[0];  
    assign w1 = w[1];  
    assign w2 = w[2];  
endmodule