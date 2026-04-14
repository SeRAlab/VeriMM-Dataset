module SHA256 (  
    input clk,  
    input rst,  
    input [511:0] message,  
    output reg [255:0] hash  
);  
    reg [511:0] msg;  
    reg [255:0] hash_temp;  
    // Initialize constants (only a few for demonstration)  
    reg [31:0] K [0:63];  
    initial begin  
        K[0] = 32'h428a2f98;  
        K[1] = 32'h71374491;  
        K[2] = 32'hb5c0fbcf;  
        K[3] = 32'he9b5dba5;  
        // ... initialize other constants  
    end  
    integer i;  
    // SHA-256 algorithm steps (simplified)  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            hash <= 256'h0;  
            hash_temp <= 256'h0;  
        end else begin  
            msg <= message;  
            // Perform message schedule and hash computation  
            // ... (pseudo steps for SHA-256)  
            // Update hash_temp  
            hash_temp <= hash_temp + K[i];  
            // At the end of processing, update the final hash  
            if (i == 63) begin  
                hash <= hash_temp;  
            end  
        end  
    end  
endmodule