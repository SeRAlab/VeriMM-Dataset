module pitch_detector(  
    input clk,  
    input rst,  
    input [7:0] audio_sample,  
    output reg [15:0] pitch_frequency  
);  
    reg [7:0] previous_sample;  
    integer zero_crossings;  
    integer sample_count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            previous_sample <= 8'b0;  
            zero_crossings <= 0;  
            sample_count <= 0;  
            pitch_frequency <= 16'b0;  
        end else begin  
            sample_count <= sample_count + 1;  
            if ((previous_sample[7] ^ audio_sample[7]) && (previous_sample != audio_sample)) begin  
                zero_crossings <= zero_crossings + 1;  
            end  
            previous_sample <= audio_sample;  

            if (sample_count >= 256) begin  
                pitch_frequency <= (zero_crossings * 44100) / 256;  
                zero_crossings <= 0;  
                sample_count <= 0;  
            end  
        end  
    end  
endmodule