module simplified_sha256 (  
    input wire clk,  
    input wire reset,  
    input wire start,  
    input wire [511:0] message,  
    output reg [255:0] hash_output,  
    output reg valid  
);  
    reg [511:0] data;  
    reg [255:0] hash;  
    reg [5:0] state;  

    parameter IDLE = 0, INIT = 1, PROCESS = 2, DONE = 3;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            hash_output <= 256'b0;  
            valid <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        data <= message;  
                        hash <= 256'h6a09e667bb67ae8584caa73b2b3c6ef372f6c18b4f5a1f14b6c1c1f9a8a2e4f; // Initial hash values  
                        state <= INIT;  
                    end  
                end  
                INIT: begin  
                    // Initialize hash and begin processing  
                    hash <= hash ^ data[255:0];  
                    state <= PROCESS;  
                end  
                PROCESS: begin  
                    // Simplified processing logic (not full SHA-256)  
                    hash <= (hash << 1) ^ (hash >> 255) ^ data[511:256];  
                    state <= DONE;  
                end  
                DONE: begin  
                    hash_output <= hash;  
                    valid <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule