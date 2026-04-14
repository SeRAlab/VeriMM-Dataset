module hamming_encoder_16to20 (  
    input [15:0] data_in,  
    output reg [19:0] encoded_out  
);  
    always @(*) begin  
        // Initialize the encoded output  
        encoded_out = 0;  
        
        // Data bits are placed in the encoded output  
        encoded_out[0]  = data_in[0];  
        encoded_out[1]  = data_in[1];  
        encoded_out[2]  = data_in[2];  
        encoded_out[3]  = data_in[3];  
        encoded_out[4]  = data_in[4];  
        encoded_out[5]  = data_in[5];  
        encoded_out[6]  = data_in[6];  
        encoded_out[7]  = data_in[7];  
        encoded_out[8]  = data_in[8];  
        encoded_out[9]  = data_in[9];  
        encoded_out[10] = data_in[10];  
        encoded_out[11] = data_in[11];  
        encoded_out[12] = data_in[12];  
        encoded_out[13] = data_in[13];  
        encoded_out[14] = data_in[14];  
        encoded_out[15] = data_in[15];  
        
        // Calculate the parity bits  
        encoded_out[16] = data_in[0] ^ data_in[1] ^ data_in[3] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14];  
        encoded_out[17] = data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[6] ^ data_in[9] ^ data_in[10] ^ data_in[13] ^ data_in[14];  
        encoded_out[18] = data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[15];  
        encoded_out[19] = data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[14] ^ data_in[15];  
    end  
endmodule