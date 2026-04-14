module HMAC (  
    input wire clk,  
    input wire rst,  
    input wire [127:0] key,  
    input wire [127:0] message,  
    input wire start,  
    output reg [127:0] hmac_out,  
    output reg done  
);  

    reg [127:0] inner_hash;  
    reg [127:0] outer_hash;  
    reg [3:0] state;  
    parameter INIT = 4'd0, INNER = 4'd1, OUTER = 4'd2, DONE = 4'd3;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= INIT;  
            hmac_out <= 128'd0;  
            done <= 1'b0;  
        end else begin  
            case (state)  
                INIT: begin  
                    if (start) begin  
                        // Perform inner hash operation, simplified as XOR for this example  
                        inner_hash <= key ^ message;  
                        state <= INNER;  
                    end  
                end  
                INNER: begin  
                    // Simulate inner hash completion  
                    outer_hash <= inner_hash ^ key;  
                    state <= OUTER;  
                end  
                OUTER: begin  
                    // Simulate outer hash completion  
                    hmac_out <= outer_hash;  
                    state <= DONE;  
                end  
                DONE: begin  
                    done <= 1'b1;  
                    state <= INIT;  
                end  
            endcase  
        end  
    end  
endmodule