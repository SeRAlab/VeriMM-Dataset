module dma_controller(  
    input clk,  
    input rst,  
    input start,  
    input [7:0] src_addr,  
    input [7:0] dest_addr,  
    input [15:0] data_in,  
    output reg [15:0] data_out,  
    output reg done  
);  
    reg [3:0] state;  
    reg [7:0] current_addr;  
    parameter IDLE = 0, TRANSFER = 1, COMPLETE = 2;  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            done <= 0;  
            data_out <= 0;  
            current_addr <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        current_addr <= src_addr;  
                        state <= TRANSFER;  
                        done <= 0;  
                    end  
                end  
                TRANSFER: begin  
                    data_out <= data_in;  
                    current_addr <= dest_addr;  
                    state <= COMPLETE;  
                end  
                COMPLETE: begin  
                    done <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule