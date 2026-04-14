module adaptive_lms_filter #(parameter DATA_WIDTH = 16, parameter STEP_SIZE = 8)  
(  
    input clk,  
    input reset,  
    input signed [DATA_WIDTH-1:0] x, // input signal  
    input signed [DATA_WIDTH-1:0] d, // desired signal  
    output reg signed [DATA_WIDTH-1:0] y, // output signal  
    output reg signed [DATA_WIDTH-1:0] error // error signal  
);  
  
    reg signed [DATA_WIDTH-1:0] w0, w1; // weights  
    reg signed [DATA_WIDTH-1:0] x_prev; // previous input signal  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            w0 <= 0;  
            w1 <= 0;  
            x_prev <= 0;  
            y <= 0;  
            error <= 0;  
        end else begin  
            // Compute output  
            y <= w0 * x + w1 * x_prev;  
            // Compute error  
            error <= d - y;  
            // Update weights using LMS  
            w0 <= w0 + (STEP_SIZE * error * x) >>> 8;  
            w1 <= w1 + (STEP_SIZE * error * x_prev) >>> 8;  
            // Update previous input  
            x_prev <= x;  
        end  
    end  
endmodule