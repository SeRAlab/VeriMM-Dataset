module IIR_Filter(  
    input clk,  
    input reset,  
    input signed [15:0] x,  
    output reg signed [15:0] z  
);  
    reg signed [15:0] a [0:3]; // Coefficients  
    reg signed [15:0] b [0:3]; // Feedback values  
    reg signed [15:0] state [0:3]; // Filter states  

    // Coefficients (example values)
    initial begin  
        a[0] = 16'h0A00;  
        a[1] = 16'h1400;  
        a[2] = 16'h1E00;  
        a[3] = 16'h1800;  
        b[0] = 16'h0C00;  
        b[1] = 16'h0A00;  
        b[2] = 16'h0800;  
        b[3] = 16'h0600;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            z <= 16'h0000;  
            state[0] <= 16'h0000;  
            state[1] <= 16'h0000;  
            state[2] <= 16'h0000;  
            state[3] <= 16'h0000;  
        end else begin  
            // 4th-order IIR filter equation implementation
            state[0] <= x - (b[1]*state[1] + b[2]*state[2] + b[3]*state[3]) >>> 12;  
            state[1] <= state[0];  
            state[2] <= state[1];  
            state[3] <= state[2];  
            z <= (a[0]*state[0] + a[1]*state[1] + a[2]*state[2] + a[3]*state[3]) >>> 12;  
        end  
    end  
endmodule