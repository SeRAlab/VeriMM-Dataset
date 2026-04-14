module adaptive_lms_filter (  
    input clk,  
    input reset,  
    input signed [15:0] x, // input signal  
    input signed [15:0] d, // desired signal  
    output reg signed [15:0] y // output signal  
);  
    reg signed [15:0] w0, w1; // filter weights  
    reg signed [15:0] x1; // delayed input signal  
    reg signed [15:0] error; // error signal  
    parameter signed [15:0] mu = 16'h0001; // step size  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            w0 <= 16'h0000;  
            w1 <= 16'h0000;  
            y <= 16'h0000;  
            x1 <= 16'h0000;  
        end else begin  
            y <= w0 * x + w1 * x1;  
            error <= d - y;  
            w0 <= w0 + (mu * error * x) >> 15;  
            w1 <= w1 + (mu * error * x1) >> 15;  
            x1 <= x;  
        end  
    end  
endmodule