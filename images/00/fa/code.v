module chacha20_stream_cipher(  
    input wire clk,  
    input wire reset,  
    input wire [255:0] key,  
    input wire [63:0] nonce,  
    input wire [31:0] block_counter,  
    output reg [255:0] keystream  
);  
    reg [255:0] state;  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            // Initialize the state with the key, nonce, and counter  
            state <= {key, nonce, block_counter};  
        end else begin  
            // Perform the ChaCha20 round function (simplified)  
            for (i = 0; i < 20; i = i + 1) begin  
                state[63:0] <= state[63:0] + state[255:192];  
                state[127:64] <= state[127:64] ^ state[63:0];  
                state[191:128] <= state[191:128] + state[127:64];  
                state[255:192] <= state[255:192] ^ state[191:128];  
            end  
            keystream <= state;  
        end  
    end  
endmodule