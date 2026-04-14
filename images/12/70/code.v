module audio_mixer(  
    input [3:0] A,  
    input [3:0] B,  
    output [3:0] Y  
);  
    wire [4:0] sum;  
    assign sum = A + B;  
    assign Y = (sum > 4'b1111) ? 4'b1111 : sum[3:0];  
endmodule