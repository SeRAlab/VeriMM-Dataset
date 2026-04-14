module echo_canceler (  
    input [15:0] audio_in,  
    input [15:0] echo_ref,  
    output reg [15:0] audio_out  
);  
    always @(audio_in or echo_ref) begin  
        audio_out = audio_in - echo_ref;  
    end  
endmodule