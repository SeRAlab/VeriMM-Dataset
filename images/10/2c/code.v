module aes_8bit (  
    input wire clk,  
    input wire [7:0] plaintext,  
    input wire [7:0] key,  
    output reg [7:0] ciphertext  
);  
    reg [7:0] state;  
    integer i;  
  
    always @(posedge clk) begin  
        // Key addition  
        state <= plaintext ^ key;  
  
        // Substitution (example: simple inversion for demonstration)  
        for (i = 0; i < 8; i = i + 1) begin  
            state[i] <= ~state[i];  
        end  
  
        // Shift operation (simple left shift for demonstration)  
        state <= {state[6:0], state[7]};  
        ciphertext <= state;  
    end  
endmodule