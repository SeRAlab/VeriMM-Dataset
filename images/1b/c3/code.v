module hamming_encoder (  
    input [7:0] data,  
    output [11:0] code  
);  
    // Parity bit calculations  
    assign code[0] = data[0] ^ data[1] ^ data[3] ^ data[4] ^ data[6];  
    assign code[1] = data[0] ^ data[2] ^ data[3] ^ data[5] ^ data[6];  
    assign code[2] = data[1] ^ data[2] ^ data[3] ^ data[7];  
    assign code[3] = data[4] ^ data[5] ^ data[6] ^ data[7];  

    // Data bits  
    assign code[4] = data[0];  
    assign code[5] = data[1];  
    assign code[6] = data[2];  
    assign code[7] = data[3];  
    assign code[8] = data[4];  
    assign code[9] = data[5];  
    assign code[10] = data[6];  
    assign code[11] = data[7];  
endmodule