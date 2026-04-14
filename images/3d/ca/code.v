module simple_des(
    input clk,
    input rst,
    input [7:0] plaintext,
    input [9:0] key,
    output reg [7:0] ciphertext
);
    
    // Simple encryption logic
    reg [7:0] encrypted;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ciphertext <= 8'b0;
        end else begin
            // Step 1: XOR with key (truncating key to 8 bits)
            encrypted = plaintext ^ {key[9:2]}; // Using upper 8 bits of key
            
            // Step 2: Simple permutation (reversing bits as a simplistic example)
            ciphertext <= {encrypted[0], encrypted[1], encrypted[2], encrypted[3],
                           encrypted[4], encrypted[5], encrypted[6], encrypted[7]};
        end
    end
endmodule