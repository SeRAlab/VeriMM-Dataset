module adaptive_lms_filter #(parameter N = 4, parameter STEP_SIZE = 8) (  
    input clk,  
    input reset,  
    input signed [15:0] x,  // input signal  
    input signed [15:0] d,  // desired signal  
    output reg signed [15:0] y, // output signal  
    output reg signed [15:0] error // error signal  
);  
    reg signed [15:0] w [0:N-1]; // coefficients  
    reg signed [15:0] x_delayed [0:N-1]; // delayed inputs  
    integer i;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            for (i = 0; i < N; i = i + 1) begin  
                w[i] <= 0;  
                x_delayed[i] <= 0;  
            end  
            y <= 0;  
            error <= 0;  
        end  
        else begin  
            // Shift delayed inputs  
            for (i = N-1; i > 0; i = i - 1) begin  
                x_delayed[i] <= x_delayed[i-1];  
            end  
            x_delayed[0] <= x;  
            
            // Calculate output  
            y <= 0;  
            for (i = 0; i < N; i = i + 1) begin  
                y <= y + w[i] * x_delayed[i];  
            end  
            
            // Calculate error  
            error <= d - y;  
            
            // Update weights  
            for (i = 0; i < N; i = i + 1) begin  
                w[i] <= w[i] + (STEP_SIZE * error * x_delayed[i]) >> 8;  
            end  
        end  
    end  
endmodule