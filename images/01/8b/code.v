module audio_compressor(  
    input [3:0] audio_sample,  
    input control_signal,  
    output reg [3:0] compressed_audio  
);  
    always @(posedge control_signal or negedge control_signal) begin  
        if (control_signal)  
            compressed_audio <= audio_sample >> 1;  
        else  
            compressed_audio <= audio_sample;  
    end  
endmodule