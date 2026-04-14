module hamming_encoder(  
    input [3:0] data_in,  
    output [6:0] code_out  
);  
    // Assign data bits  
    assign code_out[2] = data_in[0];  
    assign code_out[4] = data_in[1];  
    assign code_out[5] = data_in[2];  
    assign code_out[6] = data_in[3];  

    // Calculate parity bits  
    assign code_out[0] = data_in[0] ^ data_in[1] ^ data_in[3]; // P1  
    assign code_out[1] = data_in[0] ^ data_in[2] ^ data_in[3]; // P2  
    assign code_out[3] = data_in[1] ^ data_in[2] ^ data_in[3]; // P4  
endmodule