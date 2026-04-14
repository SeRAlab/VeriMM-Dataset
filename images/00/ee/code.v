module adaptive_lms_filter(  
    input clk,  
    input reset,  
    input [15:0] x,       // input signal  
    input [15:0] d,       // desired signal (reference)  
    input update,         // control signal to update coefficients  
    output reg [15:0] y   // output signal  
);  
    reg [15:0] w [0:3];   // filter coefficients  
    reg [15:0] e;         // error signal  
    reg [15:0] mu = 16'h0001; // step size  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            for (i = 0; i < 4; i = i + 1)  
                w[i] <= 16'h0000;  
            y <= 16'h0000;  
            e <= 16'h0000;  
        end else begin  
            // Calculate output  
            y <= (w[0] * x) + (w[1] * (x >> 1)) + (w[2] * (x >> 2)) + (w[3] * (x >> 3));  
            
            // Calculate error  
            e <= d - y;  
            
            // Update coefficients if update signal is high  
            if (update) begin  
                for (i = 0; i < 4; i = i + 1)  
                    w[i] <= w[i] + (mu * e * (x >> i));  
            end  
        end  
    end  
endmodule