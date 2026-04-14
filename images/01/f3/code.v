module hamming_encoder (
    input [15:0] data_in,
    output [19:0] codeword
);
    wire p1, p2, p3, p4;
    
    // Calculate parity bits
    assign p1 = data_in[0] ^ data_in[1] ^ data_in[3] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[9] ^ data_in[11] ^ data_in[12] ^ data_in[14]; 
    assign p2 = data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[15]; 
    assign p3 = data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[14] ^ data_in[15]; 
    assign p4 = data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[13];

    // Assign the codeword with data bits and parity bits
    assign codeword = {p4, p3, p2, p1, data_in[15:0]}; 

endmodule