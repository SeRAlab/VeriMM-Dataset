module dynamic_range_compressor (  
    input clk,  
    input reset,  
    input [11:0] audio_in,  
    output reg [11:0] audio_out  
);  
    parameter THRESHOLD = 12'd2048;  
    parameter GAIN = 12'd1024;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            audio_out <= 12'd0;  
        end else begin  
            if (audio_in > THRESHOLD)  
                audio_out <= audio_in - (audio_in - THRESHOLD) / GAIN;  
            else  
                audio_out <= audio_in;  
        end  
    end  
endmodule