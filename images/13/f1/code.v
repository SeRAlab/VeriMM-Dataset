module dma_controller(  
    input clk,  
    input rst,  
    input start,  
    input [7:0] src_addr,  
    input [7:0] dst_addr,  
    input [7:0] data_in,  
    output reg done,  
    output reg [7:0] data_out  
);  
    reg [1:0] state;  
    parameter IDLE = 2'b00, TRANSFER = 2'b01, DONE = 2'b10;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            done <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        state <= TRANSFER;  
                        done <= 0;  
                    end  
                end  
                TRANSFER: begin  
                    data_out <= data_in;  // Simulate data transfer  
                    state <= DONE;  
                end  
                DONE: begin  
                    done <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule