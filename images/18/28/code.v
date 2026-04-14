module aes_8bit (  
    input wire clk,  
    input wire rst,  
    input wire [7:0] data_in,  
    input wire [7:0] key,  
    output reg [7:0] data_out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            data_out <= 8'b0;  
        end else begin  
            // Simple AES-like transformation (for illustration purposes)  
            data_out <= data_in ^ key;  // XOR with the key for encryption  
        end  
    end  
endmodule