module hamming_encoder (  
    input [11:0] data_in,  
    output reg [15:0] code_out  
);  
    always @(*) begin  
        // Assign data bits to the output  
        code_out[11:0] = data_in;  

        // Calculate parity bits  
        code_out[12] = data_in[0] ^ data_in[1] ^ data_in[3] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10]; // P1  
        code_out[13] = data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[6] ^ data_in[9] ^ data_in[10]; // P2  
        code_out[14] = data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10]; // P3  
        code_out[15] = data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[11]; // P4  
    end  
endmodule