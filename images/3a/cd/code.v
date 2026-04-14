module md5_simple_hash(  
    input wire [127:0] data,  
    input wire clk,  
    input wire start,  
    output reg [31:0] hash,  
    output reg done  
);  
    reg [31:0] block1, block2, block3, block4;  
    reg [2:0] state;  

    localparam IDLE = 3'b000,  
               PROCESS = 3'b001,  
               DONE = 3'b010;  

    always @(posedge clk) begin  
        case (state)  
            IDLE: begin  
                if (start) begin  
                    block1 <= data[127:96];  
                    block2 <= data[95:64];  
                    block3 <= data[63:32];  
                    block4 <= data[31:0];  
                    hash <= 32'h0;  
                    state <= PROCESS;  
                    done <= 0;  
                end  
            end  
            PROCESS: begin  
                hash <= block1 ^ block2 ^ block3 ^ block4;  
                state <= DONE;  
            end  
            DONE: begin  
                done <= 1;  
                state <= IDLE;  
            end  
        endcase  
    end  
endmodule