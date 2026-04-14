module sha256 (  
    input clk,  
    input rst,  
    input [255:0] data_in,  
    input data_valid,  
    output reg [255:0] hash_out,  
    output reg hash_ready  
);  
    // Internal state and variables  
    reg [255:0] hash;  
    reg [5:0] state;  
    // States  
    localparam IDLE = 0, PROCESS = 1, DONE = 2;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            hash <= 256'h0;  
            hash_out <= 256'h0;  
            hash_ready <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (data_valid) begin  
                        hash <= hash ^ data_in; // Simple operation for example  
                        state <= PROCESS;  
                    end  
                end  
                PROCESS: begin  
                    state <= DONE;  
                end  
                DONE: begin  
                    hash_out <= hash;  
                    hash_ready <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule