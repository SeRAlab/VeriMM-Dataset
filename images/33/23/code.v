module IIR_Filter (  
    input clk,  
    input reset,  
    input x,  
    output reg y  
);  
    reg previous_output;  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            previous_output <= 0;  
            y <= 0;  
        end else begin  
            y <= x + previous_output;  
            previous_output <= y;  
        end  
    end  
endmodule