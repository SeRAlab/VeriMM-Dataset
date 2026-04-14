module chacha20_core (  
    input wire [31:0] key,  
    input wire [31:0] nonce,  
    input wire [31:0] block_index,  
    output reg [31:0] output_stream  
);  

    reg [31:0] state [0:15];  

    integer i;  

    initial begin  
        state[0] = 32'h61707865;  // "expa"  
        state[1] = 32'h3320646e;  // "nd 3"  
        state[2] = 32'h79622d32;  // "2-by"  
        state[3] = 32'h6b206574;  // "te  "  
        state[4] = key;  
        state[5] = key;  
        state[6] = key;  
        state[7] = key;  
        state[8] = block_index;  
        state[9] = nonce;  
        state[10] = nonce;  
        state[11] = nonce;  
        for (i = 0; i < 10; i = i + 1) begin  
            // Perform the quarter round operation  
            state[0] = state[0] + state[4];  
            state[12] = {state[12][30:0], state[12][31]};  
            state[8] = state[8] + state[12];  
            state[4] = {state[4][30:0], state[4][31]};  

            state[1] = state[1] + state[5];  
            state[13] = {state[13][30:0], state[13][31]};  
            state[9] = state[9] + state[13];  
            state[5] = {state[5][30:0], state[5][31]};  

            state[2] = state[2] + state[6];  
            state[14] = {state[14][30:0], state[14][31]};  
            state[10] = state[10] + state[14];  
            state[6] = {state[6][30:0], state[6][31]};  

            state[3] = state[3] + state[7];  
            state[15] = {state[15][30:0], state[15][31]};  
            state[11] = state[11] + state[15];  
            state[7] = {state[7][30:0], state[7][31]};  
        end  
        output_stream = state[0] ^ state[4] ^ state[8] ^ state[12];  
    end  
endmodule