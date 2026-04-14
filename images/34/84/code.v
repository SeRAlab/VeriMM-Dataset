module adaptive_lms_filter #(parameter N = 4)(  
    input wire clk,  
    input wire reset,  
    input wire [15:0] x_in,  
    input wire [15:0] d_in,  
    output reg [15:0] y_out  
);  
    reg [15:0] w [0:N-1];  
    reg [15:0] error;  
    reg [15:0] mu = 16'h0001; // Step size  

    integer i;  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            for (i = 0; i < N; i = i + 1)  
                w[i] <= 16'h0000;  
            y_out <= 16'h0000;  
        end else begin  
            y_out <= 16'h0000;  
            for (i = 0; i < N; i = i + 1) begin  
                y_out <= y_out + (w[i] * x_in);  
            end  
            error <= d_in - y_out;  
            for (i = 0; i < N; i = i + 1) begin  
                w[i] <= w[i] + (mu * error * x_in);  
            end  
        end  
    end  
endmodule