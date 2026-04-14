module audio_mixer(  
    input [4:0] A,  
    input [4:0] B,  
    input [4:0] C,  
    output [4:0] Y  
);  
    assign Y = (A + B + C) / 3;  
endmodule