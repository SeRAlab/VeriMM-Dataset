module dynamic_range_compressor (  
    input clk,  
    input rst,  
    input signed [15:0] in_signal,  
    input signed [15:0] threshold,  
    input signed [15:0] ratio,  
    output reg signed [15:0] out_signal  
);  

always @(posedge clk or posedge rst) begin  
    if (rst) begin  
        out_signal <= 16'b0;  
    end  
    else begin  
        if (in_signal > threshold) begin  
            out_signal <= threshold + (in_signal - threshold) / ratio;  
        end  
        else begin  
            out_signal <= in_signal;  
        end  
    end  
end  
endmodule