module adaptive_lms_filter(  
    input clk,  
    input reset,  
    input [15:0] x, // input signal  
    input [15:0] d, // desired output signal  
    output reg [15:0] y, // actual output signal  
    output reg [15:0] error, // error signal  
    output reg [15:0] w0, // tap weight 0  
    output reg [15:0] w1 // tap weight 1  
);  
    reg [15:0] x_z; // delayed input signal  
    reg [15:0] mu = 16'h0001; // step size for weight adjustment  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            w0 <= 16'h0000;  
            w1 <= 16'h0000;  
            y <= 16'h0000;  
            error <= 16'h0000;  
            x_z <= 16'h0000;  
        end else begin  
            // Update output  
            y <= (w0 * x) + (w1 * x_z);  
            // Calculate error  
            error <= d - y;  
            // Update weights  
            w0 <= w0 + (mu * error * x);  
            w1 <= w1 + (mu * error * x_z);  
            // Update delayed input signal  
            x_z <= x;  
        end  
    end  
endmodule