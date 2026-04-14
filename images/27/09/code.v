module aes_8bit (  
    input wire clk,  
    input wire rst,  
    input wire [7:0] data_in,  
    input wire [127:0] key,  
    output reg [7:0] data_out  
);  

    reg [7:0] state;  
    reg [7:0] round_key;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= 8'b0;  
            data_out <= 8'b0;  
        end else begin  
            // Simplified AES operations for 8-bit state  
            state <= data_in ^ round_key; // Key addition (XOR)  
            // (SubBytes, ShiftRows, and MixColumns operations would go here)  
            // For simplicity, we'll just rotate for this example  
            data_out <= {state[6:0], state[7]} ^ round_key; // Rotate and XOR with round_key  
            // Update round_key for next round (simple example)  
            round_key <= {key[126:0], key[127]} ^ 8'h1; // Just a dummy operation to change key  
        end  
    end  
endmodule