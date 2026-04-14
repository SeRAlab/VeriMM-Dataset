module chacha20_core(  
    input wire clk,  
    input wire reset,  
    input wire [31:0] key,  
    input wire [31:0] nonce,  
    output reg [31:0] output_block  
);  
    reg [31:0] state [0:15];  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            // Initialize state with key and nonce  
            state[0] <= key;  
            state[1] <= 32'hdeadbeef; // Sample constant value  
            state[2] <= nonce;  
            // Other state initialization can follow  
            for (i = 3; i < 16; i = i + 1) begin  
                state[i] <= 32'h0;  
            end  
        end else begin  
            // Simple operation to produce output (for demonstration)  
            output_block <= state[0] + state[1] + state[2];  
            // A real implementation would perform ChaCha20 transformations here  
        end  
    end  
endmodule