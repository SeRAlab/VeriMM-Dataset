module hamming_encoder (  
    input [3:0] data,  
    output reg [6:0] codeword  
);  
    always @(*) begin  
        // Calculate parity bits  
        codeword[0] = data[0];  
        codeword[1] = data[1];  
        codeword[2] = data[2];  
        codeword[3] = data[3];  
        codeword[4] = data[0] ^ data[1] ^ data[3]; // p1  
        codeword[5] = data[0] ^ data[2] ^ data[3]; // p2  
        codeword[6] = data[1] ^ data[2] ^ data[3]; // p3  
    end  
endmodule