module hamming_encoder (
    input [7:0] data,
    output [11:0] encoded
);
    wire p1, p2, p3, p4;
    
    // Data bits
    assign encoded[2] = data[0];
    assign encoded[4] = data[1];
    assign encoded[5] = data[2];
    assign encoded[6] = data[3];
    assign encoded[8] = data[4];
    assign encoded[9] = data[5];
    assign encoded[10] = data[6];
    assign encoded[11] = data[7];
    
    // Parity bits
    assign p1 = data[0] ^ data[1] ^ data[3] ^ data[4] ^ data[6]; // parity for bits 1, 2, 4, 5, 7
    assign p2 = data[0] ^ data[2] ^ data[3] ^ data[5] ^ data[6]; // parity for bits 1, 3, 4, 6, 7
    assign p3 = data[1] ^ data[2] ^ data[3] ^ data[7];          // parity for bits 2, 3, 4, 8
    assign p4 = data[4] ^ data[5] ^ data[6] ^ data[7];          // parity for bits 5, 6, 7, 8
    
    assign encoded[0] = p1; 
    assign encoded[1] = p2; 
    assign encoded[3] = p3; 
    assign encoded[7] = p4; 

endmodule