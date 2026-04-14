module hamming_encoder(  
    input [11:0] data_in,  
    output reg [15:0] encoded_out  
);  
    always @(*) begin  
        // Initialize the encoded output  
        encoded_out = 16'b0;  
        
        // Assign data bits to the encoded output  
        encoded_out[2] = data_in[0];  
        encoded_out[4] = data_in[1];  
        encoded_out[5] = data_in[2];  
        encoded_out[6] = data_in[3];  
        encoded_out[8] = data_in[4];  
        encoded_out[9] = data_in[5];  
        encoded_out[10] = data_in[6];  
        encoded_out[11] = data_in[7];  
        encoded_out[12] = data_in[8];  
        encoded_out[13] = data_in[9];  
        encoded_out[14] = data_in[10];  
        encoded_out[15] = data_in[11];  
        
        // Calculate parity bits  
        encoded_out[0] = encoded_out[2] ^ encoded_out[4] ^ encoded_out[6] ^ encoded_out[8] ^ encoded_out[10];  
        encoded_out[1] = encoded_out[2] ^ encoded_out[5] ^ encoded_out[6] ^ encoded_out[9] ^ encoded_out[10];  
        encoded_out[3] = encoded_out[4] ^ encoded_out[5] ^ encoded_out[6] ^ encoded_out[11];  
        encoded_out[7] = encoded_out[8] ^ encoded_out[9] ^ encoded_out[10] ^ encoded_out[11];  
    end  
endmodule