module audio_mux(  
    input wire [7:0] audio_in0,  
    input wire [7:0] audio_in1,  
    input wire sel,  
    output wire [7:0] audio_out  
);  
    assign audio_out = sel ? audio_in1 : audio_in0;  
endmodule