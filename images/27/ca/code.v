module adaptive_lms_filter #(parameter N = 5, parameter STEP_SIZE = 8'b00000001)  
(  
    input wire clk,  
    input wire reset,  
    input wire signed [15:0] x, // input signal  
    input wire signed [15:0] d, // desired signal  
    output reg signed [15:0] y // output signal  
);  
    reg signed [15:0] w [0:N-1]; // weights  
    reg signed [15:0] e; // error signal  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            for (i = 0; i < N; i = i + 1) begin  
                w[i] <= 16'b0;  
            end  
            y <= 16'b0;  
        end else begin  
            // Calculate output  
            y <= 0;  
            for (i = 0; i < N; i = i + 1) begin  
                y <= y + w[i] * x; // multiply and accumulate  
            end  

            // Calculate error  
            e <= d - y;  

            // Update weights  
            for (i = 0; i < N; i = i + 1) begin  
                w[i] <= w[i] + (STEP_SIZE * e * x); // weight update  
            end  
        end  
    end  
endmodule