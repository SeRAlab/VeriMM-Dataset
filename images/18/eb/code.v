module audio_mixer(  
    input [7:0] A,  
    input [7:0] B,  
    output reg [7:0] Y  
);  
    always @(*) begin  
        if (A == 8'b0 && B == 8'b0)  
            Y = 8'b0;  
        else  
            Y = (A + B) >> 1;  
    end  
endmodule