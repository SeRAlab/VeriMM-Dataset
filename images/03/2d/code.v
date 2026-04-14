module hamming_encoder (  
    input [7:0] data_in,  
    output reg [11:0] code_out  
);  
    always @(*) begin  
        // Assign data bits  
        code_out[2] = data_in[0];  
        code_out[4] = data_in[1];  
        code_out[5] = data_in[2];  
        code_out[6] = data_in[3];  
        code_out[8] = data_in[4];  
        code_out[9] = data_in[5];  
        code_out[10] = data_in[6];  
        code_out[11] = data_in[7];  
        
        // Calculate parity bits  
        code_out[0] = code_out[2] ^ code_out[4] ^ code_out[6] ^ code_out[8]; // p1  
        code_out[1] = code_out[2] ^ code_out[5] ^ code_out[6] ^ code_out[9]; // p2  
        code_out[3] = code_out[4] ^ code_out[5] ^ code_out[6] ^ code_out[10]; // p4  
        code_out[7] = code_out[8] ^ code_out[9] ^ code_out[10] ^ code_out[11]; // p8  
    end  
endmodule