module dma_controller(  
    input clk,  
    input rst,  
    input enable,  
    input [7:0] src_addr,  
    input [7:0] dest_addr,  
    input [7:0] data_in,  
    output reg busy,  
    output reg transfer_complete,  
    output reg [7:0] data_out  
);  

    reg [2:0] state;  
    reg [7:0] memory [0:255];  
    reg [7:0] count;  

    parameter IDLE = 3'b000, READ = 3'b001, WRITE = 3'b010, COMPLETE = 3'b011;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            busy <= 0;  
            transfer_complete <= 0;  
            count <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (enable) begin  
                        busy <= 1;  
                        state <= READ;  
                    end  
                end  

                READ: begin  
                    data_out <= memory[src_addr];  
                    state <= WRITE;  
                end  

                WRITE: begin  
                    memory[dest_addr] <= data_out;  
                    count <= count + 1;  
                    if (count == 8) begin  // Transfer 8 bytes
                        state <= COMPLETE;  
                    end else begin  
                        state <= READ;  
                    end  
                end  

                COMPLETE: begin  
                    busy <= 0;  
                    transfer_complete <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule