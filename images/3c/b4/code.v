module hmac_sha256 (  
    input wire clk,  
    input wire reset,  
    input wire [255:0] key,  
    input wire [255:0] message,  
    input wire start,  
    output reg [255:0] hmac_out,  
    output reg done  
);  
    reg [255:0] inner_hash;  
    reg [255:0] outer_hash;  
    reg [1:0] state;  
   
    parameter IDLE = 2'b00;  
    parameter INNER_HASH = 2'b01;  
    parameter OUTER_HASH = 2'b10;  
    parameter DONE = 2'b11;  
   
    // Dummy SHA-256 hash function placeholder  
    function [255:0] sha256;  
        input [255:0] data;  
        // Placeholder for hashing algorithm  
        sha256 = {data[127:0], data[255:128]}; // Simple swap for demonstration  
    endfunction  
   
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            hmac_out <= 256'b0;  
            done <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        inner_hash <= sha256({key, message});  
                        state <= INNER_HASH;  
                    end  
                end  
                INNER_HASH: begin  
                    outer_hash <= sha256({key, inner_hash});  
                    state <= OUTER_HASH;  
                end  
                OUTER_HASH: begin  
                    hmac_out <= outer_hash;  
                    done <= 1;  
                    state <= DONE;  
                end  
                DONE: begin  
                    done <= 1;  
                end  
            endcase  
        end  
    end  
endmodule