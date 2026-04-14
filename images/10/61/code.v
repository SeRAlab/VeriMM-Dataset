module AES_8bit (  
    input wire [7:0] plain_text,  
    input wire [7:0] key,  
    input wire clk,  
    input wire start,  
    output reg [7:0] cipher_text,  
    output reg done  
);  
    reg [7:0] expanded_key;  
    reg [7:0] state;  
    reg [2:0] round;  

    // Simple key expansion logic (for demonstration purposes)  
    always @(posedge clk) begin  
        if (start) begin  
            expanded_key <= key ^ 8'h1; // Simple transformation for key expansion  
            state <= plain_text;  
            round <= 3'b000;  
            done <= 0;  
        end else if (round < 3'b100) begin  
            // Simple round transformation (for demonstration purposes)  
            state <= state ^ expanded_key; // Simple XOR operation  
            round <= round + 1;  
        end else if (round == 3'b100) begin  
            cipher_text <= state;  
            done <= 1;  
        end  
    end  
endmodule