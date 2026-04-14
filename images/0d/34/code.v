module rgb_to_yuv (  
    input [7:0] R,  
    input [7:0] G,  
    input [7:0] B,  
    output reg [7:0] Y,  
    output reg [7:0] U,  
    output reg [7:0] V  
);  
    always @(*) begin  
        Y = (R * 299 + G * 587 + B * 114) / 1000;  
        U = ((R * -14713 + G * -28886 + B * 43600) / 100000) + 128;  
        V = ((R * 61500 + G * -51499 + B * -10001) / 100000) + 128;  
    end  
endmodule