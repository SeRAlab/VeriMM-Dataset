module hamming_encoder (  
    input [11:0] data,  
    output [15:0] encoded  
);  
    wire p1, p2, p3, p4;  
    wire [11:0] d;  
    assign d = data;  

    assign p1 = d[0] ^ d[1] ^ d[3] ^ d[4] ^ d[6] ^ d[8] ^ d[10];  
    assign p2 = d[0] ^ d[2] ^ d[3] ^ d[5] ^ d[6] ^ d[8] ^ d[9];  
    assign p3 = d[1] ^ d[2] ^ d[3] ^ d[7] ^ d[8] ^ d[9];  
    assign p4 = d[4] ^ d[5] ^ d[6] ^ d[7] ^ d[8] ^ d[9];  

    assign encoded[0] = p1;  
    assign encoded[1] = p2;  
    assign encoded[2] = d[0];  
    assign encoded[3] = p3;  
    assign encoded[4] = d[1];  
    assign encoded[5] = d[2];  
    assign encoded[6] = d[3];  
    assign encoded[7] = d[4];  
    assign encoded[8] = p4;  
    assign encoded[9] = d[5];  
    assign encoded[10] = d[6];  
    assign encoded[11] = d[7];  
    assign encoded[12] = d[8];  
    assign encoded[13] = d[9];  
    assign encoded[14] = d[10];  
    assign encoded[15] = d[11];  
endmodule