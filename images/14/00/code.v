module hmac_sha256 (  
    input clk,  
    input rst,  
    input [127:0] key,  
    input [127:0] message,  
    output reg [127:0] hmac  
);  
    // Internal registers  
    reg [127:0] inner_hash;  
    reg [127:0] outer_hash;  

    // SHA-256 stub (for demonstration)  
    function [127:0] sha256;  
        input [127:0] data;  
        begin  
            // Simple hash function for demonstration purposes; replace with actual SHA-256  
            sha256 = data ^ 128'hA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5;  
        end  
    endfunction  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            hmac <= 128'b0;  
        end else begin  
            // Step 1: Inner hash  
            inner_hash <= sha256(key ^ message);  
            // Step 2: Outer hash  
            outer_hash <= sha256(key ^ inner_hash);  
            // Step 3: Output the HMAC  
            hmac <= outer_hash;  
        end  
    end  
endmodule