module HMAC (  
    input clk,  
    input rst,  
    input [127:0] key,  
    input [127:0] message,  
    output reg [127:0] hmac  
);  
    reg [127:0] inner_hash;  
    reg [127:0] outer_hash;  
    reg [127:0] padded_key;  
    reg [3:0] state;  

    // State Definitions  
    parameter INIT = 0, PADDING = 1, INNER_HASH = 2, OUTER_HASH = 3, DONE = 4;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            hmac <= 0;  
            inner_hash <= 0;  
            outer_hash <= 0;  
            padded_key <= 0;  
            state <= INIT;  
        end else begin  
            case (state)  
                INIT: begin  
                    // Key padding logic  
                    padded_key <= key; // Assume key is already the right size  
                    state <= PADDING;  
                end  
                PADDING: begin  
                    // Compute inner hash (for simplicity, we just concatenate here)  
                    inner_hash <= {padded_key, message};  
                    state <= INNER_HASH;  
                end  
                INNER_HASH: begin  
                    // Normally we would hash inner_hash here, for simplicity we just use it as it is.  
                    outer_hash <= inner_hash;  
                    state <= OUTER_HASH;  
                end  
                OUTER_HASH: begin  
                    // Output the final HMAC (again, just passing through for simplicity)  
                    hmac <= outer_hash;  
                    state <= DONE;  
                end  
                DONE: begin  
                    // Stay in done state  
                end  
            endcase  
        end  
    end  
endmodule