module des_encryption (  
    input wire [63:0] data,  
    input wire [63:0] key,  
    input wire clk,  
    input wire rst,  
    output reg [63:0] encrypted_data  
);  

    // Simple round function for encryption (for illustration purposes)  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            encrypted_data <= 64'b0;  
        else  
            encrypted_data <= data ^ key;  // simple XOR operation  
    end  
endmodule