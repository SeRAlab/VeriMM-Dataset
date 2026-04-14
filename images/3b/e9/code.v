module sha256_simple (  
    input clk,  
    input rst,  
    input [255:0] message,  
    output reg [255:0] hash  
);  

    reg [255:0] internal_hash;  
    reg [511:0] padded_message;  

    // Simple initialization of hash values
    initial begin  
        internal_hash = 256'h6a09e667bb67ae8583f6000ca6eaf48c8f9f4f4f96b3b6c6a4c88d3f3a8b7e82;  
    end  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            internal_hash <= 256'h6a09e667bb67ae8583f6000ca6eaf48c8f9f4f4f96b3b6c6a4c88d3f3a8b7e82;  
            hash <= 256'h0;  
        end else begin  
            // Padding the message (simplified for this example)
            padded_message = {message, 448'b0};  
            // Simple hash computation (not real SHA-256)
            internal_hash = internal_hash ^ padded_message[255:0];  
            hash <= internal_hash;  
        end  
    end  
endmodule