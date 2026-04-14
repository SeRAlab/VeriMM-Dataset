module noise_suppression_filter(  
    input clk,  
    input rst,  
    input [7:0] in_signal,  
    input [7:0] threshold,  
    output reg [7:0] out_signal  
);  
    reg [7:0] delay_reg;  
    reg filtered;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            delay_reg <= 0;  
            out_signal <= 0;  
            filtered <= 0;  
        end else begin  
            if (in_signal > threshold) begin  
                out_signal <= delay_reg;  
                filtered <= 1;  
            end else begin  
                out_signal <= in_signal;  
                filtered <= 0;  
            end  
            delay_reg <= in_signal;  
        end  
    end  
endmodule