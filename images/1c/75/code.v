module hamming_encoder (  
    input [15:0] data,  
    output [20:0] codeword  
);  
    wire [4:0] parity;  
    assign codeword[0] = data[0];  
    assign codeword[1] = data[1];  
    assign codeword[2] = data[2];  
    assign codeword[3] = data[3];  
    assign codeword[4] = data[4];  
    assign codeword[5] = data[5];  
    assign codeword[6] = data[6];  
    assign codeword[7] = data[7];  
    assign codeword[8] = data[8];  
    assign codeword[9] = data[9];  
    assign codeword[10] = data[10];  
    assign codeword[11] = data[11];  
    assign codeword[12] = data[12];  
    assign codeword[13] = data[13];  
    assign codeword[14] = data[14];  
    assign codeword[15] = data[15];  

    // Calculate parity bits  
    assign parity[0] = data[0] ^ data[1] ^ data[3] ^ data[4] ^ data[6] ^ data[8] ^ data[9] ^ data[11] ^ data[12];  
    assign parity[1] = data[0] ^ data[2] ^ data[3] ^ data[5] ^ data[6] ^ data[8] ^ data[10] ^ data[11] ^ data[13];  
    assign parity[2] = data[1] ^ data[2] ^ data[3] ^ data[7] ^ data[8] ^ data[9] ^ data[10] ^ data[11] ^ data[14];  
    assign parity[3] = data[4] ^ data[5] ^ data[6] ^ data[7] ^ data[8] ^ data[9] ^ data[10] ^ data[11] ^ data[15];  
    assign parity[4] = data[12] ^ data[13] ^ data[14] ^ data[15];  

    assign codeword[16] = parity[0];  
    assign codeword[17] = parity[1];  
    assign codeword[18] = parity[2];  
    assign codeword[19] = parity[3];  
    assign codeword[20] = parity[4];  
endmodule