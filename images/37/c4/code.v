module simple_des (  
    input wire clk,  
    input wire rst,  
    input wire [63:0] plaintext,  
    input wire [55:0] key,  
    output reg [63:0] ciphertext  
);  
    reg [63:0] left, right;  
    reg [55:0] round_key;  
    integer i;  

    // Initial key schedule (simplified, one round for demonstration)
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            left <= 64'b0;  
            right <= 64'b0;  
            ciphertext <= 64'b0;  
        end else begin  
            left <= plaintext[63:32];  
            right <= plaintext[31:0];  
            round_key <= key;  
              
            // 16 rounds of the Feistel function (simplified to a single XOR for demonstration)
            for (i = 0; i < 16; i = i + 1) begin  
                {left, right} <= {right, left ^ (right ^ round_key)};  
            end  
            ciphertext <= {left, right};  
        end  
    end  
endmodule