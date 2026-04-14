module adaptive_lms_filter #(parameter N = 5) (  
    input clk,  
    input rst,  
    input signed [15:0] x,  // input signal  
    input signed [15:0] d,  // desired signal  
    output reg signed [15:0] y  // output signal  
);  

    reg signed [15:0] w [0:N-1];  // filter coefficients  
    reg signed [15:0] e;           // error signal  
    reg signed [15:0] mu = 16'd1;  // step size  

    integer i;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            for (i = 0; i < N; i = i + 1) begin  
                w[i] <= 16'd0;  
            end  
            y <= 16'd0;  
        end else begin  
            y <= 16'd0;  
            for (i = 0; i < N; i = i + 1) begin  
                y <= y + (w[i] * x);  
            end  
            e <= d - y;  
            for (i = 0; i < N; i = i + 1) begin  
                w[i] <= w[i] + (mu * e * x);  
            end  
        end  
    end  
endmodule