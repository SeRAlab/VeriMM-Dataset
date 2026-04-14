module sha256_simple (  
    input wire clk,  
    input wire rst,  
    input wire start,  
    input wire [511:0] message,  
    output reg [255:0] hash_out,  
    output reg ready  
);  
    reg [3:0] state;  
    reg [255:0] intermediate_hash;  
    parameter IDLE = 4'b0000,  
              COMPUTE = 4'b0001,  
              DONE = 4'b0010;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            hash_out <= 256'b0;  
            ready <= 1'b0;  
            intermediate_hash <= 256'b0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        intermediate_hash <= 256'h6a09e667bb67ae8584caa73b2c7c0a0; // Initial hash value  
                        state <= COMPUTE;  
                    end  
                end  
                COMPUTE: begin  
                    // Simulate hash computation  
                    // In a real case, you would perform the actual SHA-256 algorithm here  
                    intermediate_hash <= intermediate_hash + message[255:0]; // Simplified operation  
                    state <= DONE;  
                end  
                DONE: begin  
                    hash_out <= intermediate_hash;  
                    ready <= 1'b1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule