module hamming_encoder(  
    input [10:0] data,  
    output [15:0] codeword  
);  
    assign codeword[0] = data[0] ^ data[1] ^ data[3] ^ data[4] ^ data[6];  
    assign codeword[1] = data[0] ^ data[2] ^ data[3] ^ data[5] ^ data[6];  
    assign codeword[2] = data[1] ^ data[2] ^ data[3] ^ data[7];  
    assign codeword[3] = data[0] ^ data[1] ^ data[2] ^ data[3] ^ data[4] ^ data[5] ^ data[7];  
    assign codeword[4] = data[4] ^ data[5] ^ data[6] ^ data[7];  
    assign codeword[5] = data[8];  
    assign codeword[6] = data[9];  
    assign codeword[7] = data[10];  
    assign codeword[8] = data[0];  
    assign codeword[9] = data[1];  
    assign codeword[10] = data[2];  
    assign codeword[11] = data[3];  
    assign codeword[12] = data[4];  
    assign codeword[13] = data[5];  
    assign codeword[14] = data[6];  
    assign codeword[15] = data[7];  
endmodule