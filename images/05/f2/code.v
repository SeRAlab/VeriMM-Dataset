module hamming_encoder(  
    input [11:0] data_in,  
    output [15:0] encoded_out  
);  
    wire [3:0] p;  
    assign p[0] = data_in[0] ^ data_in[1] ^ data_in[3] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[9] ^ data_in[11];  
    assign p[1] = data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[11];  
    assign p[2] = data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11];  
    assign p[3] = data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11];  

    assign encoded_out = {p[3], p[2], data_in[0], p[1], data_in[1], data_in[2], data_in[3], data_in[4], p[0], data_in[5], data_in[6], data_in[7], data_in[8], data_in[9], data_in[10], data_in[11]};  
endmodule