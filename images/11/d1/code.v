module aes_8bit (  
    input [7:0] plaintext,  
    input [7:0] key,  
    input clk,  
    input start,  
    output reg [7:0] ciphertext,  
    output reg done  
);  

    reg [7:0] state;  

    always @(posedge clk) begin  
        if (start) begin  
            state <= plaintext ^ key; // Simple XOR operation as encryption  
            done <= 0;  
        end else begin  
            ciphertext <= state;  
            done <= 1;  
        end  
    end  
endmodule