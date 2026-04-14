module sha256 (  
    input clk,  
    input rst,  
    input start,  
    input [255:0] data_in,  
    output reg [255:0] hash_out,  
    output reg done  
);  
    reg [255:0] hash;  
    reg [511:0] message;  
    reg [5:0] state;  
    parameter IDLE = 0, PROCESS = 1, OUTPUT = 2;  
    initial begin  
        hash = 256'h0;  
        state = IDLE;  
        done = 0;  
    end  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            hash <= 256'h0;  
            done <= 0;  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        message <= {data_in, 256'h0};  
                        state <= PROCESS;  
                    end  
                end  
                PROCESS: begin  
                    // Simplified SHA-256 processing logic (not complete)  
                    hash <= hash + message[255:0]; // Example operation  
                    // In a real implementation, more complex operations would be done  
                    state <= OUTPUT;  
                end  
                OUTPUT: begin  
                    hash_out <= hash;  
                    done <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule