module dynamic_range_compressor(  
    input clk,  
    input reset,  
    input signed [15:0] audio_in,  
    input signed [15:0] threshold,  
    input [3:0] compression_ratio,  
    output reg signed [15:0] audio_out  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            audio_out <= 16'b0;  
        end else begin  
            if (audio_in > threshold) begin  
                audio_out <= (audio_in - threshold) >> compression_ratio;  
            end else begin  
                audio_out <= audio_in;  
            end  
        end  
    end  
endmodule