module chacha20_core (  
    input wire clk,  
    input wire rst,  
    input wire [31:0] key,  
    input wire [31:0] nonce,  
    output reg [31:0] ciphertext,  
    output reg valid  
);  
    reg [31:0] state [0:3];  
    integer i;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state[0] <= key;  
            state[1] <= nonce;  
            state[2] <= 32'h00000001; // Initial counter  
            state[3] <= 32'hC0BBAA55; // Constant value  
            valid <= 0;  
        end else begin  
            // Simple transformation: XOR and rotate  
            for (i = 0; i < 10; i = i + 1) begin  
                state[0] <= state[0] + state[1];  
                state[1] <= {state[1][16:0], state[1][31:16]}; // rotate  
                state[2] <= state[2] ^ state[0];  
                state[3] <= state[3] + state[2];  
                state[2] <= {state[2][8:0], state[2][31:8]}; // rotate  
            end  
            ciphertext <= state[0] ^ state[1] ^ state[2] ^ state[3];  
            valid <= 1;  
        end  
    end  
endmodule