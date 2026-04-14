module chacha20_round (  
    input [255:0] key,  
    input [63:0] nonce,  
    output reg [255:0] state  
);  
    reg [31:0] v[0:7];  
    integer i;  

    initial begin  
        v[0] = key[31:0];  
        v[1] = key[63:32];  
        v[2] = key[95:64];  
        v[3] = key[127:96];  
        v[4] = key[159:128];  
        v[5] = key[191:160];  
        v[6] = key[223:192];  
        v[7] = key[255:224];  
        v[0] = v[0] + nonce[31:0];  
        v[1] = v[1] + nonce[63:32];  
        // Perform the ChaCha20 quarter round operation  
        for (i = 0; i < 8; i = i + 2) begin  
            v[i] = v[i] + v[i+1];  
            v[i+1] = (v[i+1] << 16) | (v[i+1] >> (32 - 16));  
            v[i+1] = v[i+1] ^ v[i];  
            v[i] = (v[i] << 12) | (v[i] >> (32 - 12));  
        end  
        // Assign output state  
        state = {v[0], v[1], v[2], v[3], v[4], v[5], v[6], v[7]};  
    end  
endmodule