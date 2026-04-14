module dma_controller (  
    input clk,  
    input rst,  
    input start,  
    input [7:0] src_addr,  
    input [7:0] dst_addr,  
    input [7:0] data_in,  
    output reg [7:0] data_out,  
    output reg complete  
);  
    reg [7:0] memory [255:0]; // Simple memory array  
    reg [7:0] src, dst;  
    reg [3:0] state;  
    
    localparam IDLE = 4'b0000,  
               TRANSFER = 4'b0001,  
               DONE = 4'b0010;  
    
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            complete <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        src <= src_addr;  
                        dst <= dst_addr;  
                        state <= TRANSFER;  
                        complete <= 0;  
                    end  
                end  
                TRANSFER: begin  
                    data_out <= memory[src];  
                    memory[dst] <= data_out;  
                    state <= DONE;  
                end  
                DONE: begin  
                    complete <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule