module aes_128_encrypt (  
    input wire clk,  
    input wire reset,  
    input wire [127:0] plaintext,  
    input wire [127:0] key,  
    output reg [127:0] ciphertext  
);  
    reg [127:0] state;  
    reg [127:0] round_key;  

    // Simple round function (for demonstration, not actual AES)  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= 128'b0;  
            ciphertext <= 128'b0;  
        end else begin  
            round_key <= key;  
            state <= plaintext ^ round_key;  // Simple XOR operation  
            ciphertext <= state;  
        end  
    end  
endmodule