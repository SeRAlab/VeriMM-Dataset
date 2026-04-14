module dynamic_range_compressor (  
    input clk,  
    input reset,  
    input signed [3:0] audio_in,  
    input signed [3:0] threshold,  
    input [2:0] compression_ratio,  
    output reg signed [3:0] audio_out  
);  
    reg signed [3:0] prev_output;  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            audio_out <= 4'd0;  
            prev_output <= 4'd0;  
        end else begin  
            if (audio_in > threshold) begin  
                audio_out <= (audio_in - threshold) >> compression_ratio;  
            end else begin  
                audio_out <= audio_in;  
            end  
            prev_output <= audio_out;  
        end  
    end  
endmodule