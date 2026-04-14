module adaptive_lms_filter #(parameter N = 5, parameter STEP_SIZE = 16'h0001)  
(  
    input clk,  
    input reset,  
    input signed [15:0] x,  // input signal  
    input signed [15:0] d,  // desired output signal  
    output reg signed [15:0] y // actual output signal  
);  
    reg signed [15:0] w [0:N-1];  // weights  
    reg signed [15:0] e;           // error signal  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            for (i = 0; i < N; i = i + 1)  
                w[i] <= 16'h0000;  
            y <= 16'h0000;  
        end else begin  
            // Calculate output  
            y <= 16'h0000;  
            for (i = 0; i < N; i = i + 1)  
                y <= y + (w[i] * x);  
            
            // Calculate error  
            e <= d - y;  
            
            // Update weights  
            for (i = 0; i < N; i = i + 1)  
                w[i] <= w[i] + (STEP_SIZE * e * x);  
        end  
    end  
endmodule