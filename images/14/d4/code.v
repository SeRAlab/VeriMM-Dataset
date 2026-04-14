module adaptive_lms_filter #(parameter N = 5, parameter LEARNING_RATE = 8'h1) (  
    input clk,  
    input reset,  
    input signed [15:0] x,  
    input signed [15:0] d,  
    output signed [15:0] y  
);  
    reg signed [15:0] w [0:N-1];  
    reg signed [15:0] y_reg;  
    reg signed [15:0] error;  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            for (i = 0; i < N; i = i + 1)  
                w[i] <= 16'b0;  
            y_reg <= 16'b0;  
        end else begin  
            y_reg <= 16'b0;  
            for (i = 0; i < N; i = i + 1) begin  
                y_reg <= y_reg + (w[i] * x);  
            end  
            error <= d - y_reg;  
            for (i = 0; i < N; i = i + 1) begin  
                w[i] <= w[i] + (LEARNING_RATE * error * x);  
            end  
        end  
    end  

    assign y = y_reg;  
endmodule