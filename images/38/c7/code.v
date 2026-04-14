module fir_filter(  
    input [3:0] x,  
    input clk,  
    input rst,  
    output reg [4:0] y  
);  
    reg [3:0] delay [0:4]; // 5 delay elements  
    integer i;  
    
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            for (i = 0; i < 5; i = i + 1)  
                delay[i] <= 0;  
            y <= 0;  
        end else begin  
            // Shift inputs  
            delay[0] <= x;  
            for (i = 1; i < 5; i = i + 1)  
                delay[i] <= delay[i-1];  
            
            // Compute output using filter coefficients 1,2,3,2,1  
            y <= (1 * delay[0]) + (2 * delay[1]) + (3 * delay[2]) + (2 * delay[3]) + (1 * delay[4]);  
        end  
    end  
endmodule