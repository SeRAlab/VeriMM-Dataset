module hamming_encoder(  
    input [7:0] data_in,  
    output reg [11:0] codeword  
);  
    always @(*) begin  
        // Assign data bits  
        codeword[2:0] = data_in[2:0];  
        codeword[6:4] = data_in[5:3];  
        codeword[10:7] = data_in[7:6];  
        
        // Calculate parity bits  
        codeword[3] = data_in[0] ^ data_in[1] ^ data_in[3] ^ data_in[4]; // p1  
        codeword[7] = data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[4] ^ data_in[5]; // p2  
        codeword[11] = data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[5]; // p4  
        codeword[8] = data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[6]; // p8  
    end  
endmodule