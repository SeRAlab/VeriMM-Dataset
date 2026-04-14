module dynamic_range_compressor (  
    input clk,  
    input rst,  
    input signed [15:0] in_signal,  
    output reg signed [15:0] out_signal  
);  
    parameter THRESHOLD = 16'h0F00; // Compression threshold  
    parameter SCALE_FACTOR = 4; // Scaling factor for compression  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            out_signal <= 16'sd0;  
        end else begin  
            if (in_signal > THRESHOLD) begin  
                out_signal <= in_signal / SCALE_FACTOR;  
            end else begin  
                out_signal <= in_signal;  
            end  
        end  
    end  
endmodule