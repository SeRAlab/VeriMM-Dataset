module simplified_DES(  
    input clk,  
    input reset,  
    input [63:0] plaintext,  
    input [55:0] key,  
    output reg [63:0] ciphertext  
);  
    // Internal registers for operations  
    reg [63:0] data_reg;  
    reg [55:0] key_reg;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_reg <= 64'b0;  
            key_reg <= 56'b0;  
            ciphertext <= 64'b0;  
        end else begin  
            // Simple substitution (for example purposes)  
            data_reg <= plaintext ^ {key_reg[55:0], key_reg[55:0] >> 8};  
            // Simple permutation (for example purposes)  
            ciphertext <= {data_reg[63:56], data_reg[55:48], data_reg[47:40], data_reg[39:32],  
                           data_reg[31:24], data_reg[23:16], data_reg[15:8], data_reg[7:0]};  
        end  
    end  
endmodule