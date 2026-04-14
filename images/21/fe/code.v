module fir_filter (  
    input [3:0] x,  
    input clk,  
    input rst,  
    output reg [3:0] y  
);  
    reg [3:0] x_delay [0:3];  
    integer i;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            for (i = 0; i < 4; i = i + 1)  
                x_delay[i] <= 4'b0000;  
            y <= 4'b0000;  
        end else begin  
            x_delay[0] <= x;  
            x_delay[1] <= x_delay[0];  
            x_delay[2] <= x_delay[1];  
            x_delay[3] <= x_delay[2];  
            y <= (x_delay[0] * 1 + x_delay[1] * 2 + x_delay[2] * 3 + x_delay[3] * 4) >> 2;  
        end  
    end  
endmodule