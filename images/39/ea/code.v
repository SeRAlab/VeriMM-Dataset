module simplified_des(  
    input wire [63:0] plaintext,  
    input wire [63:0] key,  
    input wire clk,  
    input wire rst,  
    output reg [63:0] ciphertext  
);  
    reg [63:0] subkeys [0:15];  
    reg [63:0] data;  
    integer i;  
      
    // Key schedule (simplified for illustration)  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            // Initialize subkeys  
            for (i = 0; i < 16; i = i + 1) begin  
                subkeys[i] = key ^ (i + 1);  // Simple XOR for subkey generation  
            end  
            data <= plaintext;  
            ciphertext <= 64'b0;  
        end else begin  
            // Perform 16 rounds of processing  
            for (i = 0; i < 16; i = i + 1) begin  
                data <= data ^ subkeys[i];  // Simplified round function  
            end  
            ciphertext <= data;  
        end  
    end  
endmodule