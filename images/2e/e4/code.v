module dma_controller(  
    input clk,  
    input reset,  
    input start,  
    input [7:0] src_addr,  
    input [7:0] dest_addr,  
    input [15:0] data,  
    output reg busy,  
    output reg done,  
    output reg [15:0] out_data  
);  

    reg [1:0] state;  
    parameter IDLE = 2'b00, READ = 2'b01, WRITE = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            busy <= 0;  
            done <= 0;  
            out_data <= 16'b0;  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        busy <= 1;  
                        state <= READ;  
                    end  
                end  
                READ: begin  
                    out_data <= data;  // simulate reading from src_addr  
                    state <= WRITE;  
                end  
                WRITE: begin  
                    // simulate writing to dest_addr  
                    busy <= 0;  
                    done <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule